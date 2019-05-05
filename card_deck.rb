class CardDeck
  attr_reader :card_deck
  def initialize
    @card_deck = []
    @suits = { clubs: "\u2663", diamonds: "\u2666", hearts: "\u2665", spades: "\u2660" }
    @names = { ace: 'Т', jack: 'В', queen: 'Д', king: 'К' }
    @card_values = (2..10)
    generate_cards_nominal
    generate_cards_name
    shuffle_cards
  end

  def take_card
    @card_deck.pop
  end

  private

  # генерация карт без картинок, только номинал
  def generate_cards_nominal
    @suits.each do |suit, symbol|
      @card_values.each do |card_value|
        # puts "Card value: #{utf_symbol}"
        @card_deck << {
          suit: suit, name: :none, pic: card_value.to_s + symbol, value: card_value
        }
      end
    end
  end

  # генерация карт с картинками
  def generate_cards_name
    @suits.each do |suit, symbol|
      @names.each do |name, letter|
        @card_deck << if name == :ace
                        { suit: suit, name: :ace, pic: letter + symbol, value_big: 11, value_small: 1 }
                      else
                        { suit: suit, name: name, pic: letter + symbol, value: 10 }
                      end
      end
    end
  end

  def shuffle_cards
    @card_deck.shuffle!
  end
end
