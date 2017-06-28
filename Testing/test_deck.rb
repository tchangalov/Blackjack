# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# 
# CLASS DECRIPTION:
# Tests all methods and member assignments in the Card and
# Deck class.

#!/usr/bin/env ruby
$:.unshift("#{File.dirname(__FILE__)}/../")

require 'test/unit'
require 'Card'
require 'Deck'

class Test_Card_and_Deck < Test::Unit::TestCase
	######## Test Class Objects ##########
	def test_instances
		my_deck = Deck.new
		assert_instance_of(Deck, my_deck)

		temp_card = Card.new("A", "Hearts")
		assert_instance_of(Card, temp_card)
	end

	######## Card ##########
	# Test cards belonging in the card class
	def test_card_members
		card = Card.new("A", "Hearts")
		assert_equal(card.value, 1)
		assert_equal(card.face, "A")
		assert_equal(card.is_ace, true)
	end

	def test_to_s
		card = Card.new(4, "Diamonds")
		assert_equal(card.value, 4)
		assert_equal(card.face, 4)
		assert_equal(card.suit, "Diamonds")
		assert_equal(card.is_ace, false)
		assert_match(card.to_s, "4 of Diamonds")
	end

	######## Deck ##########
	def test_length
		my_deck = Deck.new
		assert_equal(my_deck.length, 52)
	end

	def test_deal
		my_deck = Deck.new
		temp_card = my_deck.deal
		assert(temp_card.class == Card)
		assert_equal(my_deck.length, 51)
	end

	# Further Testing: Deck::Shuffle and Deck to_s
end
