class Card
  attr_reader :name

  SUITS = { clubs: "\u2663", diamonds: "\u2666", hearts: "\u2665", spades: "\u2660" }.freeze
  NAMES = { ace: 'Т', jack: 'В', queen: 'Д', king: 'К' }.freeze

  def initialize(suit, name)
    @suit = suit
    @name = name
  end

  def pic
    "#{card_symbol}#{SUITS[@suit]}"
  end

  def value
    if @name.is_a?(Integer)
      @name
    elsif @name == :ace
      11
    else
      10
    end
  end

  private

  def card_symbol
    @name.is_a?(Integer) ? @name.to_s : NAMES[@name]
  end
end
