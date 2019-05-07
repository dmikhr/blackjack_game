module Strategies
  def strategy(value)
    if value
      @dealer.take_card(@card_deck)
    elsif @dealer.consecutive_missed_moves < 1
      @dealer.miss_move
    end
  end

  def default_strategy
    strategy(@dealer.score < 17)
  end

  def random_strategy
    strategy(rand(1..2).even?)
  end
end
