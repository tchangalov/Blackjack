# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# 
# CLASS DECRIPTION:
# Tests all methods and member assignments for the player class

#!/usr/bin/env ruby
$:.unshift("#{File.dirname(__FILE__)}/../")

require 'test/unit'
require 'Dealer'
require 'Player'
require 'Card'
require 'Deck'

class Test_Player < Test::Unit::TestCase
	######## Test Class Objects ##########
	def test_hands
		# Create object
		player = Player.new
		deck = Deck.new
		dealer = Dealer.new(player)
		
		# Try to deal to player and make sure values are updated correctly
		dealer.deal(player)
		assert(player.hands.length == 1)

		# Have to manually update value since it's done in deal method
		player.hands << Card.new("A", "Hearts")
		player.value += 1
		assert(player.value == player.hands[0].value + 1)

		player.hands << Card.new("K", "Diamonds")
		assert(player.hands.length == 3)

		assert(player.has_val(10) == true)
		assert(player.has_val(15) == false)

		assert(player.has_face("A") == true)
		assert(player.has_face("L") == false)

	end
end
