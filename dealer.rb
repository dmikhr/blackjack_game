class Dealer < Participant
  def initialize(name = '')
    super
    @name = 'Дилер'
  end

  def miss_move
    super if @score >= 17
  end

  def take_card(card_deck)
    super(card_deck) if @score < 17
  end
end
