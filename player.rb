class Player < Participant

  def take_card(card_deck)
    # Добавить карту (только если у пользователя на руках 2 карты)
    super(card_deck) if @cards.size == 2
  end

end
