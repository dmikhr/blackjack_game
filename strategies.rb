module Strategies
  def default_strategy
    if @dealer.score < 17
      @dealer.take_card(@card_deck)
    else
      @dealer.miss_move if @dealer.consecutive_missed_moves <= 1
    end
  end

  def random_strategy
    if rand(1..2).even?
      @dealer.take_card(@card_deck)
    else
      @dealer.miss_move if @dealer.consecutive_missed_moves <= 1
    end
  end
end
