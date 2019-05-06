require_relative 'bank'
require_relative 'card'
require_relative 'deck'
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
    @win_status = {
      draw: 'Ничья',
      dealer_wins: 'Выиграл дилер',
      player_wins: "Выиграл игрок #{@player_name}",
      both_lose: 'Выигравших нет'
    }
    @commands = [
      {
        method: :player_miss_move,
        description: 'Пропустить ход',
        success_msg: 'Игрок пропускает ход',
        fail_msg: 'Можно пропустить ход только 1 раз'
      },
      {
        method: :player_take_card,
        description: 'Добавить карту',
        success_msg: "#{@player_name} взял карту",
        fail_msg: "#{@player_name}: уже имеет 3 карты, больше взять нельзя"
      },
      {
        method: :open_cards,
        description: 'Открыть карты',
        success_msg: 'Открываем карты',
        fail_msg: 'open_cards: ошибка'
      }
    ]
  end

  def show_options
    puts 'Доступные команды:'
    @commands.each.with_index(1) { |cmd, idx| puts "#{idx} - #{cmd[:description]}" }
  end

  def play_game
    @game.new_game
    puts "\nДобро пожаловать в игру Блэкджек"
    show_options
    loop do
      puts "Карты игрока: #{@game.show_player_cards}"
      puts "Карты дилера: #{@game.show_dealer_cards_hidden}"
      # puts "\n"
      puts 'Введите вариант действий (введите "999" для выхода из игры)'
      command = gets.chomp
      break if command == '999'

      execute_command(command)
      if @game.game_over?
        show_game_results(@game.game_results)
        break unless play_again
      end
    end
  end

  private

  def show_game_results(results)
    puts 'Игра окончена'
    puts "Карты игрока #{results[:player_cards]} Очки: #{results[:player_score]}"
    puts "Карты дилера #{results[:dealer_cards]} Очки: #{results[:dealer_score]}"
    puts "Результат: #{@win_status[results[:winner]]}"
    puts "Состояние банка - Дилер: #{results[:bank].dealer_account},"\
          " Игрок: #{results[:bank].player_account}, "\
          "Игра: #{results[:bank].game_account}"
  end

  def debug_data(game_obj)
    items = %i[player dealer game_status game_over? bank]
    items.each do |item|
      puts "DEBUG: #{item}"
      p game_obj.public_send(item)
    end
  end

  def ask_player_name
    puts 'Введите имя'
    @player_name = gets.chomp
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
    command = @commands[cmd_index - 1]
    if @game.respond_to?(command[:method])
      if @game.public_send(command[:method])
        puts command[:success_msg]
      else
        puts command[:fail_msg]
      end
      debug_data(@game) if DEBUG
    else
      puts 'Неизвестная команда'
    end
  end
end
