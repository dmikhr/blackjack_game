class Deck
  attr_reader :card_deck
  def initialize
    @card_deck = []
    generate_cards
    shuffle_cards
  end

  def take_card
    @card_deck.pop
  end

  private

  # генерация карт
  def generate_cards
    names = Card::NAMES.keys + (2..10).to_a
    Card::SUITS.keys.each do |suit|
      names.each do |name|
        @card_deck << Card.new(suit, name)
      end
    end
  end

  def shuffle_cards
    @card_deck.shuffle!
  end
end
