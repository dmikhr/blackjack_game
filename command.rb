require_relative 'card_deck'
require_relative 'participant'
require_relative 'player'
require_relative 'dealer'
require_relative 'rubyjack'

# взаимодействие с игрой со стороны игрока
# выполнение команд - взять карту, пропустить ход, открыть карты
class Command
  DEBUG = true
  def initialize
    ask_player_name
    @game = RubyJack.new(@player_name)
  end

  def play_game
    @game.new_game
    puts "\nДобро пожаловать в игру Блэкджек"
    @game.show_options
    loop do
      @game.show_player_cards
      # puts "\n"
      puts 'Введите вариант действий (введите "999" для выхода из игры)'
      command = gets.chomp
      break if command == '999'

      execute_command(command)
      if @game.game_over?
        @game.game_results
        break unless play_again
      end
    end
  end

  private

  def debug_data(game_obj)
    puts 'DEBUG: Player'
    p game_obj.player
    puts 'DEBUG: Dealer'
    p game_obj.dealer
    puts 'DEBUG: game_over'
    p game_obj.game_status
    puts 'DEBUG: game_over?'
    p game_obj.game_over?
    # puts 'DEBUG: Card Deck'
    # p game_obj.card_deck
  end

  def ask_player_name
    puts 'Введите имя'
    @player_name = gets.chomp
    # @player_name = 'Джек'
  end

  def play_again
    puts 'Хотите сыграть еще раз? (да/нет)'
    answer = gets.chomp
    case answer
    when 'да'
      play_game
    when 'нет'
      puts 'Игра завершена'
      false
    else
      puts 'Введите да или нет'
      # если введено что-то кроме да или нет - рекурсивно вызываем этот же метод
      play_again
    end
  end

  def execute_command(cmd_index)
    cmd_index = cmd_index.to_i
    if defined? @game.commands[cmd_index - 1][1]
      @game.commands[cmd_index - 1][1].call
      debug_data(@game) if DEBUG
    else
      puts 'Неизвестная команда'
    end
  end
end
