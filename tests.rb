require 'test/unit'
require_relative 'strategies'
require_relative 'card'
require_relative 'deck'
require_relative 'bank'
require_relative 'participant'
require_relative 'player'
require_relative 'dealer'
require_relative 'rubyjack'
require_relative 'command'

class BlackJackTest < Test::Unit::TestCase
  # проверяем, что генерируется полная колода
  def test_card_deck
    deck = Deck.new
    assert_equal(52, deck.card_deck.size)
  end

  # тестируем класс банк
  def test_bank_init
    bank = Bank.new
    assert_equal(100, bank.player_account)
    assert_equal(100, bank.dealer_account)
    assert_equal(0, bank.game_account)
  end

  def test_make_stake
    bank = Bank.new
    bank.make_stake
    assert_equal(90, bank.player_account)
    assert_equal(90, bank.dealer_account)
    assert_equal(20, bank.game_account)
  end

  def test_participants_have_money
    bank = Bank.new
    assert_equal(true, bank.participants_have_money?)
  end

  def test_return_money
    bank = Bank.new
    bank.make_stake
    bank.return_money
    assert_equal(100, bank.player_account)
    assert_equal(100, bank.dealer_account)
    assert_equal(0, bank.game_account)
  end

  def test_pay_to_dealer
    bank = Bank.new
    bank.make_stake
    bank.pay_to_dealer
    assert_equal(90, bank.player_account)
    assert_equal(110, bank.dealer_account)
    assert_equal(0, bank.game_account)
  end

  def test_pay_to_player
    bank = Bank.new
    bank.make_stake
    bank.pay_to_player
    assert_equal(110, bank.player_account)
    assert_equal(90, bank.dealer_account)
    assert_equal(0, bank.game_account)
  end

  # тестируем конечное состояние игры, когда у обоих участников есть по 3 карты
  def test_draw
    game = RubyJack.new('Joe')
    game.new_game
    game.dealer.cards = [
      Card.new(:clubs, 9),
      Card.new(:diamonds, 8),
      Card.new(:clubs, 4)
    ]
    game.player.cards = [
      Card.new(:spades, 8),
      Card.new(:hearts, 3),
      Card.new(:spades, :queen)
    ]
    game.dealer.calculate_score
    game.player.calculate_score
    assert_equal(21, game.dealer.score)
    assert_equal(21, game.player.score)
    assert_equal(:draw, game.game_results[:winner])
  end

  def test_player_wins
    game = RubyJack.new('Joe')
    game.new_game
    game.dealer.cards = [
      Card.new(:diamonds, :queen),
      Card.new(:spades, 4),
      Card.new(:spades, 2)
    ]
    game.player.cards = [
      Card.new(:hearts, 9),
      Card.new(:hearts, :jack),
      Card.new(:diamonds, 2)
    ]
    game.dealer.calculate_score
    game.player.calculate_score
    assert_equal(16, game.dealer.score)
    assert_equal(21, game.player.score)
    assert_equal(:player_wins, game.game_results[:winner])
  end

  def test_dealer_wins
    game = RubyJack.new('Joe')
    game.new_game
    game.dealer.cards = [
      Card.new(:hearts, 9),
      Card.new(:hearts, :jack),
      Card.new(:diamonds, 1)
    ]
    game.player.cards = [
      Card.new(:diamonds, :king),
      Card.new(:spades, 4),
      Card.new(:diamonds, 1)
    ]
    game.dealer.calculate_score
    game.player.calculate_score
    assert_equal(20, game.dealer.score)
    assert_equal(15, game.player.score)
    assert_equal(:dealer_wins, game.game_results[:winner])
  end

  def test_both_lose
    game = RubyJack.new('Joe')
    game.new_game
    game.dealer.cards = [
      Card.new(:hearts, :queen),
      Card.new(:diamonds, 7),
      Card.new(:spades, 7)
    ]
    game.player.cards = [
      Card.new(:clubs, 4),
      Card.new(:diamonds, :queen),
      Card.new(:diamonds, :jack)
    ]
    game.dealer.calculate_score
    game.player.calculate_score
    assert_equal(24, game.dealer.score)
    assert_equal(24, game.player.score)
    assert_equal(:both_lose, game.game_results[:winner])
  end

  def test_ace_11
    game = RubyJack.new('German')
    game.new_game
    game.player.cards = [
      Card.new(:spades, 3),
      Card.new(:spades, 7),
      Card.new(:spades, :ace)
    ]
    game.player.calculate_score
    assert_equal(21, game.player.score)
  end

  def test_ace_1
    game = RubyJack.new('Joe')
    game.new_game
    game.dealer.cards = [
      Card.new(:clubs, 9),
      Card.new(:diamonds, :ace),
      Card.new(:spades, 7)
    ]
    game.dealer.calculate_score
    assert_equal(17, game.dealer.score)
  end
end
