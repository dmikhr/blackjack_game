class Participant
  attr_reader :score, :name
  attr_accessor :cards, :bank

  def initialize(name = '')
    @cards = []
    @bank = 100
    @score = 0
    @name = name
  end

  def miss_move; end

  def take_card(card_deck)
    if @cards.size == 2
      @cards << card_deck.take_card
      calculate_score
    end
  end

  def open_cards
    @cards
  end

  def calculate_score
    aces = []
    score = 0
    @cards.each do |card|
      if card[:name] == :ace
        aces << card
      else
        score += card[:value]
      end
    end
    # отдельно считаем очки от тузов, если тузы есть
    score += ace_score(aces) unless aces.empty?
    @score = score
  end

  protected

  def ace_score(aces)
    ace = aces[0]
    if aces.size == 1
      # если туз с номиналом 11 не приводит к проигрышу, считаем номинал 11
      @score + ace[:value1] <= 21 ? ace[:value_big] : ace[:value_small]
    elsif aces.size >= 2
      # обобщение на случай N тузов
      # если туза 2 и более: считаем 11+1+..+1
      # 1-ый туз по номиналу 11, оставшиеся по 1
      # на основе обсуждения задания на http://connect.thinknetica.com/t/topic/1539
      ace[:value_big] + (aces.size - 1) + ace[:value_small]
    end
  end

end
