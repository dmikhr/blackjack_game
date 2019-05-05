module Strategies
  def default_strategy
    if @dealer.score < 17
      puts 'Дилер берет карту (score < 17)'
      @dealer.take_card(@card_deck)
    else
      puts 'Дилер пропускает ход (score >= 17)'
      @dealer.miss_move if @dealer.consecutive_missed_moves < 1
    end
  end

  def random_strategy
    if rand(1..2).even?
      puts 'Дилер берет карту (random)'
      @dealer.take_card(@card_deck)
    else
      puts 'Дилер пропускает ход (random)'
      @dealer.miss_move if @dealer.consecutive_missed_moves < 1
    end
  end
end
