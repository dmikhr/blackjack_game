# class game
# класс управляющий игрой
# идея названия класса взята из обсуждения
# http://connect.thinknetica.com/t/proekt-igra-blek-dzhek/1539/32

class RubyJack
  include Strategies

  attr_reader :commands, :player, :dealer, :card_deck, :game_bank, :game_status, :bank

  def initialize(player_name)
    @player_name = player_name
    # учет баланса ведется в течении всех серий игр
    @bank = Bank.new
  end

  def new_game
    @game_status = :playing
    # перемешанная колода карт
    @card_deck = Deck.new
    # создаем объекты игрока и дилера
    @player = Player.new(@player_name)
    @dealer = Dealer.new
    # раздача карт
    give_initial_cards(@player)
    give_initial_cards(@dealer)
    if @bank.participants_have_money?
      @bank.make_stake
    else
      game_over
    end
  end

  def game_over?
    @game_status == :finished || both_have_3_cards?
  end

  def player_take_card
    @player.consecutive_missed_moves = 0
    dealer_play if @player.take_card(card_deck)
  end

  def player_miss_move
    # если игрок еще не пропускал ход
    if @player.consecutive_missed_moves < 1
      @player.miss_move
      # пропускаем ход и передаем ход дилеру
      dealer_play
    end
  end

  def dealer_play
    default_strategy
    # random_strategy
  end

  # передаем результаты игры в виде хеша
  # в интерфейс Command, где происходит вывод данных
  def game_results
    {
      winner: determine_winner,
      player_score: @player.score,
      dealer_score: @dealer.score,
      dealer_cards: show_dealer_cards,
      player_cards: show_player_cards,
      bank: @bank
    }
  end

  def show_player_cards
    @player.show_cards
  end

  # показать вместо карт дилера звездочки
  def show_dealer_cards_hidden
    (['*'] * @dealer.cards.size).join(' ')
  end

  def determine_winner
    if player_wins?
      player_wins
    elsif dealer_wins?
      dealer_wins
    elsif draw?
      draw
    elsif both_lose?
      both_lose
    end
  end

  def game_over
    @game_status = :finished
  end

  # т.к. открытие карт ведет к завершению игры, поведение
  # метода open_cards идентично game_over
  alias_method :open_cards, :game_over

  private

  def show_dealer_cards
    @dealer.show_cards
  end

  def player_wins?
    (@player.score > @dealer.score && @player.score <= 21) ||
      (@dealer.score > @player.score && @dealer.score > 21 && @player.score <= 21)
  end

  def dealer_wins?
    (@dealer.score > @player.score && @dealer.score <= 21) ||
      (@player.score > @dealer.score && @player.score > 21 && @dealer.score <= 21)
  end

  def draw?
    @dealer.score == @player.score && @dealer.score <= 21 && @player.score <= 21
  end

  def both_lose?
    @dealer.score > 21 && @player.score > 21
  end

  def both_have_3_cards?
    @player.cards.size == 3 && @dealer.cards.size == 3
  end

  def give_initial_cards(participant)
    2.times { participant.cards << @card_deck.take_card }
    participant.calculate_score
  end

  # ничья
  def draw
    @bank.return_money
    :draw
  end

  def dealer_wins
    @bank.pay_to_dealer
    :dealer_wins
  end

  def player_wins
    @bank.pay_to_player
    :player_wins
  end

  def both_lose
    @bank.reset_account
    :both_lose
  end
end
