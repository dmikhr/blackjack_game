# class game
# класс управляющий игрой
# идея названия класса взята из обсуждения
# http://connect.thinknetica.com/t/proekt-igra-blek-dzhek/1539/32

class RubyJack
  include Strategies

  attr_reader :commands, :player, :dealer, :card_deck, :game_bank, :game_status
  STAKE = 10

  def initialize(player_name)
    @commands = [
      ['Пропустить ход', method(:player_miss_move)],
      ['Добавить карту', method(:player_take_card)],
      ['Открыть карты', method(:open_cards)]
    ]
    @player_name = player_name
    new_game
  end

  def show_options
    puts 'Доступные команды:'
    @commands.each.with_index(1) { |cmd, idx| puts "#{idx} - #{cmd[0]}" }
  end

  def new_game
    @game_status = :playing
    # перемешанная колода карт
    @card_deck = CardDeck.new
    # создаем объекты игрока и дилера
    @player = Player.new(@player_name)
    @dealer = Dealer.new
    # раздача карт
    give_initial_cards(@player)
    give_initial_cards(@dealer)
    if player_has_money? && dealer_has_money?
      make_stake
    else
      game_results
    end
  end

  def make_stake
    @player.bank -= STAKE
    @dealer.bank -= STAKE
    @game_bank ||= 0
    @game_bank += 2 * STAKE
  end

  def game_over?
    @game_status == :finished || both_have_3_cards?
  end

  def player_take_card
    @player.consecutive_missed_moves = 0
    if @player.take_card(card_deck)
      puts "#{@player.name} взял карту"
      # p @player.cards
    else
      puts "#{@player.name}: уже имеет 3 карты, больше взять нельзя"
    end
    dealer_play
  end

  def player_miss_move
    # игрок пропускает ход, ходит дилер
    if @player.consecutive_missed_moves < 1
      puts 'Игрок пропускает ход'
      @player.miss_move
      # пропускаем ход и передаем ход дилеру
      dealer_play
    else
      # нужно выбрать другое действие - взять карту или открыть карты
      # в этом случае пользователь не сделал ход, т.е. дилеру ход не передаем
      puts 'Можно пропустить ход только 1 раз'
    end
  end

  def open_cards
    puts 'Открываем карты'
    game_results
  end

  def dealer_play
    default_strategy
    # random_strategy
  end

  def game_results
    game_over
    puts 'Игра окончена'
    show_player_cards
    puts "Очки игрока (#{@player.name}) #{@player.score}"
    show_dealer_cards
    puts "Очки дилера #{@dealer.score}"
    find_winner
  end

  def show_player_cards
    puts "Карты игрока #{@player.name}: #{@player.show_cards}"
  end

  private

  def find_winner
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

  def show_dealer_cards
    puts "Карты дилера: #{@dealer.show_cards}"
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

  def game_over
    @game_status = :finished
  end

  def both_have_3_cards?
    @player.cards.size == 3 && @dealer.cards.size == 3
  end

  def give_initial_cards(participant)
    2.times { participant.cards << @card_deck.take_card }
    participant.calculate_score
  end

  def player_has_money?
    @player.bank - STAKE >= 0
  end

  def dealer_has_money?
    @dealer.bank - STAKE >= 0
  end

  # ничья
  def draw
    puts 'Ничья'
    @player.bank += 10
    @dealer.bank += 10
    @game_bank = 0
    # возвращаем символом статус победы
    # используется в юнит тестах
    :draw
  end

  def dealer_wins
    puts 'Выграл дилер'
    @dealer.bank += @game_bank
    @game_bank = 0
    :dealer_wins
  end

  def player_wins
    puts "Выиграл игрок #{player.name}"
    @player.bank += @game_bank
    @game_bank = 0
    :player_wins
  end

  def both_lose
    # оба набрали больше 21 - деньги остаются в банке
    puts 'Выигравших нет'
    :both_lose
  end
end
