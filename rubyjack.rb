# class game
# класс управляющий игрой

class RubyJack
  attr_reader :commands, :player, :dealer, :card_deck, :game_bank

  def initialize(player_name)
    @commands = [
      ['Пропустить ход', method(:player_miss_move)],
      ['Добавить карту', method(:player_take_card)],
      ['Открыть карты', method(:open_cards)],
    ]
    # перемешанная колода карт
    @card_deck = CardDeck.new
    # создаем объекты игрока и дилера
    @player = Player.new(player_name)
    @dealer = Dealer.new
    # раздача карт
    give_initial_cards(@player)
    give_initial_cards(@dealer)
    # ставка в банк игры
    @player.bank -= 10
    @dealer.bank -= 10
    @game_bank = 20
    #p @player
    #p @dealer
    @game_status = :playing
  end

  def show_options
    puts 'Доступные команды:'
    @commands.each.with_index(1) { |cmd, idx| puts "#{idx} - #{cmd[0]}" }
  end

  def dealer_play
    if @dealer.score < 17
      puts "Дилер берет карту"
      @dealer.take_card(@card_deck)
    else
      puts "Дилер пропускает ход"
      @dealer.miss_move
    end
  end

  def game_over?
    @game_status == :finished
  end

  def game_over
    @game_status = :finished
  end

  def both_have_3_cards
    if @player.cards.size == 3 && @dealer.cards.size == 3
      puts 'Оба игрока имеют по 3 карты - игра окончена'
      game_results
    end
  end

  def player_miss_move
    # игрок пропускает ход, ходит дилер
    puts 'Игрок пропускает ход'
    dealer_play
  end

  def open_cards
    puts 'Открываем карты'
    @player.open_cards
    @dealer.open_cards
    game_results
  end

  def game_results
    game_over
    puts 'Игра окончена'
    puts "Очки игрока (#{@player.name}) #{@player.score}"
    puts "Очки дилера #{@dealer.score}"
    find_winner
  end

  def find_winner
    case
    when (@player.score > @dealer.score && @player.score <= 21) || (@dealer.score > @player.score && @dealer.score > 21)
      player_wins
    when (@dealer.score > @player.score && @dealer.score <= 21) || (@player.score > @dealer.score && @player.score > 21)
      dealer_wins
    when @dealer.score == @player.score && @dealer.score <= 21 && @player.score <= 21
      draw
    else
      puts 'Неучтенная ситуация'
    end
  end

  def participant_take_card(person)
    person == :player ? participant = @player : participant = @dealer
    if participant.take_card(card_deck)
      puts "#{participant.name} взял карту"
      p participant.cards
    else
      puts "#{participant.name}: уже имеет 3 карты, больше взять нельзя"
    end
  end

  def player_take_card
    puts 'Игрок взял карту'
    if @player.take_card(card_deck)
      puts "#{@player.name} взял карту"
      #p @player.cards
    else
      puts "#{@player.name}: уже имеет 3 карты, больше взять нельзя"
    end
  end

  private

  def give_initial_cards(participant)
    2.times { participant.cards << @card_deck.take_card }
  end

  # ничья
  def draw
    puts 'Ничья'
    @player.bank += 10
    @dealer.bank += 10
    @game_bank = 0
  end

  def dealer_wins
    puts 'Выграл дилер'
    @dealer.bank += @game_bank
    @game_bank = 0
  end

  def player_wins
    puts "Выиграл игрок #{player.name}"
    @player.bank += @game_bank
    @game_bank = 0
  end
end
