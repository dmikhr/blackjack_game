require 'test/unit'
require_relative 'strategies'
require_relative 'card_deck'
require_relative 'participant'
require_relative 'player'
require_relative 'dealer'
require_relative 'rubyjack'
require_relative 'command'

class BlackJackTest < Test::Unit::TestCase

  # проверяем, что генерируется полная колода
  def test_card_deck
    deck = CardDeck.new
    assert_equal(52, deck.card_deck.size )
  end

  # тестируем конечное состояние игры, когда у обоих участников есть по 3 карты
  def test_draw
    game = RubyJack.new('Joe')
    game.dealer.cards = [{:suit=>:clubs, :name=>:none, :pic=>"9♣", :value=>9}, {:suit=>:diamonds, :name=>:none, :pic=>"8♦", :value=>8}, {:suit=>:clubs, :name=>:none, :pic=>"4♣", :value=>4}]
    game.player.cards = [{:suit=>:spades, :name=>:none, :pic=>"8♠", :value=>8}, {:suit=>:hearts, :name=>:none, :pic=>"3♥", :value=>3}, {:suit=>:spades, :name=>:jack, :pic=>"В♠", :value=>10}]
    game.player.calculate_score
    game.dealer.calculate_score
    assert_equal(:draw, game.open_cards)
  end

  def test_player_wins
    game = RubyJack.new('Joe')
    game.dealer.cards = [{:suit=>:diamonds, :name=>:none, :pic=>"10♦", :value=>10}, {:suit=>:spades, :name=>:none, :pic=>"4♠", :value=>4}, {:suit=>:diamonds, :name=>:none, :pic=>"2♦", :value=>1}]
    game.player.cards = [{:suit=>:hearts, :name=>:none, :pic=>"9♥", :value=>9}, {:suit=>:hearts, :name=>:jack, :pic=>"В♥", :value=>10}, {:suit=>:diamonds, :name=>:none, :pic=>"5♦", :value=>1}]
    game.player.calculate_score
    game.dealer.calculate_score
    assert_equal(:player_wins, game.open_cards)
  end

  def test_dealer_wins
    game = RubyJack.new('Joe')
    game.dealer.cards = [{:suit=>:hearts, :name=>:none, :pic=>"9♥", :value=>9}, {:suit=>:hearts, :name=>:jack, :pic=>"В♥", :value=>10}, {:suit=>:diamonds, :name=>:none, :pic=>"5♦", :value=>1}]
    game.player.cards = [{:suit=>:diamonds, :name=>:none, :pic=>"10♦", :value=>10}, {:suit=>:spades, :name=>:none, :pic=>"4♠", :value=>4}, {:suit=>:diamonds, :name=>:none, :pic=>"2♦", :value=>1}]
    game.player.calculate_score
    game.dealer.calculate_score
    assert_equal(:dealer_wins, game.open_cards)
  end

  def test_both_lose
    game = RubyJack.new('Joe')
    game.dealer.cards = [{:suit=>:hearts, :name=>:queen, :pic=>"Д♥", :value=>10}, {:suit=>:diamonds, :name=>:none, :pic=>"7♦", :value=>7}, {:suit=>:spades, :name=>:none, :pic=>"7♠", :value=>7}]
    game.player.cards = [{:suit=>:clubs, :name=>:none, :pic=>"4♣", :value=>4}, {:suit=>:diamonds, :name=>:none, :pic=>"10♦", :value=>10}, {:suit=>:diamonds, :name=>:jack, :pic=>"В♦", :value=>10}]
    game.player.calculate_score
    game.dealer.calculate_score
    assert_equal(:both_lose, game.open_cards)
  end

end
