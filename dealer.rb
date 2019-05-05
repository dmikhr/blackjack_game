class Dealer < Participant
  def initialize(name = '')
    super
    @name = 'Дилер'
  end

  def miss_move
    # puts 'Дилер пропускает ход, @score >= 17'
    super if @score >= 17
  end

  def take_card(card_deck)
    # Добавить карту (если очков менее 17)
    # puts 'Дилер берет карту, @score < 17'
    super(card_deck) if @score < 17
  end
end
