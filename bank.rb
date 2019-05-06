class Bank
  STAKE = 10

  attr_reader :player_account, :dealer_account, :game_account

  def initialize
    @player_account = 100
    @dealer_account = 100
    @game_account = 0
  end

  def make_stake
    @player_account -= STAKE
    @dealer_account -= STAKE
    @game_account += 2 * STAKE
  end

  def participants_have_money?
    player_has_money? && dealer_has_money?
  end

  def return_money
    @player_account += STAKE
    @dealer_account += STAKE
    @game_account -= 2 * STAKE
  end

  def pay_to_dealer
    @dealer_account += @game_account
    @game_account = 0
  end

  def pay_to_player
    @player_account += @game_account
    @game_account = 0
  end

  # когда и у дилера и игрока > 21
  # оба считаются проигравшими
  # деньги не возвращаются, а банк игры обнуляется
  def reset_account
    @game_account = 0
  end

  private

  def player_has_money?
    @player_account - STAKE >= 0
  end

  def dealer_has_money?
    @dealer_account - STAKE >= 0
  end
end
