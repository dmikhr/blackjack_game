module Strategies
  def default_strategy
    if @dealer.score < 17
      @dealer.take_card(@card_deck)
    elsif @dealer.consecutive_missed_moves < 1
      @dealer.miss_move
    end
  end

  def random_strategy
    if rand(1..2).even?
      @dealer.take_card(@card_deck)
    elsif @dealer.consecutive_missed_moves < 1
      @dealer.miss_move
    end
  end
end
