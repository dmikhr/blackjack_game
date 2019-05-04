class CardDeck
  attr_reader :card_deck
  def initialize
    @card_deck = []
    # масть карты
    @suits = %w[clubs diamonds hearts spades]
    @names = %w[ace jack queen king]
    @card_values = (2..10)
    generate_cards_nominal
    generate_cards_name
    shuffle_cards
  end

  def take_card
    @card_deck.pop
  end

  # array of hashes
  # each hash represents a card
  #card = {suit: clubs, name: jack, value: 10}
  private

  def generate_cards_nominal
    @suits.each do |suit|
      @card_values.each do |card_value|
        @card_deck << { suit: suit, name: 'none', value: card_value }
      end
    end
  end

  def generate_cards_name
    @suits.each do |suit|
      @names.each do |name|
        if @name == 'ace'
          @card_deck << { suit: suit, name: name, value1: 11, value2: 1 }
        else
          @card_deck << { suit: suit, name: name, value: 10 }
        end
      end
    end
  end

  def shuffle_cards
    @card_deck.shuffle!
  end

end
