class Card
  attr_reader :name, :pic, :value

  def initialize(suit, name, pic, value)
    @suit = suit
    @name = name
    @pic = pic
    @value = value
  end
end
