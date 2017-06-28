# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# 
# CLASS DECRIPTION:
# Tests all methods and member assignments for the dealer class.  The purpose of this test
# class is to take the important code snippets and test them against
# important decisions that the program has to make to assure that they
# correct. Further testing would include run-time testing. There shouldn't be any issues
# with that since "set up" checks if game ended, then the compare method checks
# the cases where player hits and busts, dealer hits and busts, or both stand

#!/usr/bin/env ruby
$:.unshift("#{File.dirname(__FILE__)}/../")

require 'test/unit'
require 'Dealer'
require 'Player'
require 'Card'
require 'Deck'

class Test_Dealer < Test::Unit::TestCase
	# Not going to test the playing loop (Dealer::begin and Dealer::play)
	# Those were tested by playing the game itself

	# For the setup method, I only copied two lines

	# Both have blackjack
	def test_setup_game_both_blackjack
		player = Player.new
		dealer = Dealer.new(player)
		
		# Give player new cards
		player.hands << Card.new("A", "Hearts")
		player.hands << Card.new("J", "Kings")

		# Give dealer cards
		dealer.hands << Card.new("A", "Diamonds")
		dealer.hands << Card.new("Q", "Kings")
		
		# Assert correct winner
        d_has_blackjack = dealer.has_face("A") && dealer.has_val(10)
        p_has_blackjack = player.has_face("A") && player.has_val(10)

        assert(d_has_blackjack)
        assert(p_has_blackjack)
    end

    # One person has blackjack
    def test_setup_game_ONE_has_blackjack
		player = Player.new
		dealer = Dealer.new(player)

		player.hands << Card.new("A", "Hearts")
		player.hands << Card.new(4, "Kings")

		dealer.hands << Card.new("A", "Diamonds")
		dealer.hands << Card.new("K", "Kings")

        d_has_blackjack = dealer.has_face("A") && dealer.has_val(10)
        p_has_blackjack = player.has_face("A") && player.has_val(10)

        assert(d_has_blackjack)
        assert(!p_has_blackjack)
    end

    # No one has blackjack
    def test_setup_game_none_have_blackjack
		player = Player.new
		dealer = Dealer.new(player)

		player.hands << Card.new(5, "Hearts")
		player.hands << Card.new(4, "Kings")

		dealer.hands << Card.new(6, "Diamonds")
		dealer.hands << Card.new(6, "Kings")
		
		d_has_blackjack = dealer.has_face("A") && dealer.has_val(10)
        p_has_blackjack = player.has_face("A") && player.has_val(10)

        assert(!d_has_blackjack)
        assert(!p_has_blackjack)
    end

    # No Aces - test hit and stand
    def test_compute_dealer_move1
    	player = Player.new
		dealer = Dealer.new(player)

		player.hands << Card.new(5, "Hearts")
		player.hands << Card.new(4, "Kings")
		# Manually updating since deck's deal method does this
		# But gives a random card. Here I want to deal a specific one
		player.value += 9

		dealer.hands << Card.new(6, "Diamonds")
		dealer.hands << Card.new(6, "Kings")
		dealer.value += 12
		
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "hit")
        dealer.hands << Card.new(5, "Spades")
        dealer.value += 5

        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "stand")
    end

    # Only 1 Ace - test hit and stand
    def test_compute_dealer_move2
    	player = Player.new
		dealer = Dealer.new(player)
		# Manually updating since deck's deal method does this
		# But gives a random card. Here I want to deal a specific one
		dealer.hands << Card.new("A", "Diamonds")
		dealer.hands << Card.new(6, "Kings")
		dealer.value += (1 + 6)

		# Tests exact threshold (7 or 17) = (hit or stand) = stand takes precedence
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "stand")

        dealer.hands << Card.new(5, "Spades")
        dealer.value += 5

        # here we have eiteher (12 or 22) = (hit or stand (busted)) = hit takes precedence
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "hit")
        
        dealer.hands << Card.new(5, "Hearts")
        dealer.value += 5

        # here we have eiteher (19 or 29) = (stand or stand (busted)) = stand
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "stand")
        
        dealer.hands << Card.new(7, "Hearts")
        dealer.value += 7

        # adding a card of 7 means he just chose to hit but (26 or 36). should stand
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "stand")
    end

    # 2 and 3 Aces - test hit and stand (Only one Ace can be at 11)
    def test_compute_dealer_move3
    	player = Player.new
		dealer = Dealer.new(player)
		# Manually updating since deck's deal method does this
		# But gives a random card. Here I want to deal a specific one
		dealer.hands << Card.new("A", "Diamonds")
		dealer.hands << Card.new("A", "Kings")
		dealer.value += (1 + 1)

		# Two Aces if they were both 11 is a bust, thus only one ace can exist
		# Tests exact threshold (2 or 12) = (hit or hit) = hit takes precedence
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "hit")

        dealer.hands << Card.new(4, "Spades")
        dealer.value += 4

        # here we have eiteher (6 or 16) = (hit or hit) = hit takes precedence
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "hit")
        
        dealer.hands << Card.new("A", "Hearts")
        dealer.value += 1

        # here we have eiteher (7 or 17) = (hit or stand) = stand
        assert_match(dealer.compute_dealer_move(dealer, dealer.hands), "stand")
    end

   def test_compare_the_two
    	player = Player.new
		dealer = Dealer.new(player)

		dealer.hands << Card.new(4, "Diamonds")
		dealer.hands << Card.new(10, "Kings")
        dealer.value += 14

		player.hands << Card.new(4, "Diamonds")
		player.hands << Card.new(10, "Kings")
		player.value += 14

		# Player: 14 / Dealer: 14
        assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Tie")

       	dealer.hands << Card.new(10, "Spades")
	    dealer.value += 10

	    # Player: 14 / Dealer: 24
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Player")

		player.hands << Card.new(10, "Hearts")
	    player.value += 10

	    # Player: 24 / Dealer: 24
	    assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")
    end

    # Player Busts
    def test_compare_the_two_part2
    	player = Player.new
		dealer = Dealer.new(player)

		dealer.hands << Card.new(4, "Diamonds")
		dealer.hands << Card.new(10, "Kings")
        dealer.value += 14

		player.hands << Card.new(4, "Diamonds")
		player.hands << Card.new(10, "Kings")
		player.hands << Card.new(10, "Hearts")
	    player.value += 10 + 10 + 4

	    # Player: 24 / Dealer: 14
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")
    end

    # Dealer Busts
    def test_compare_the_two_part_two3
    	player = Player.new
		dealer = Dealer.new(player)

		dealer.hands << Card.new(4, "Diamonds")
		dealer.hands << Card.new(10, "Kings")
        dealer.value += 14

		player.hands << Card.new(10, "Kings")
		player.hands << Card.new(10, "Hearts")
	    player.value += 10 + 10

	    # Player: 20 / Dealer: 14
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Player")

       	dealer.hands << Card.new(10, "Spades")
        dealer.value += 10

        # Player: 20 / Dealer: 24
        assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Player")

    end

    # Dealer has Blackjack
    def test_compare_the_two_part_two4
    	player = Player.new
		dealer = Dealer.new(player)

		dealer.hands << Card.new(9, "Diamonds")
		dealer.hands << Card.new(10, "Kings")
		dealer.hands << Card.new(2, "Spades")
        dealer.value += 21

		player.hands << Card.new(10, "Kings")
		player.hands << Card.new(10, "Hearts")
	    player.value += 10 + 10

	    # Player: 20 / Dealer: 21
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")
    end

    # Player has Blackjack
    def test_compare_the_two_part_two5
    	player = Player.new
		dealer = Dealer.new(player)

		dealer.hands << Card.new(10, "Kings")
		dealer.hands << Card.new(10, "Hearts")
	    dealer.value += 10 + 10

		player.hands << Card.new(9, "Diamonds")
		player.hands << Card.new(10, "Kings")
		player.hands << Card.new(2, "Spades")
        player.value += 21

	    # Player: 21 / Dealer: 20
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Player")
    end

    # Both have Blackjack
    def test_compare_the_two_part_two6
    	player = Player.new
		dealer = Dealer.new(player)

		dealer.hands << Card.new(9, "Diamonds")
		dealer.hands << Card.new(10, "Kings")
		dealer.hands << Card.new(2, "Spades")
	    dealer.value += 21

		player.hands << Card.new(9, "Diamonds")
		player.hands << Card.new(10, "Kings")
		player.hands << Card.new(2, "Spades")
        player.value += 21

	    # Player: 21 / Dealer: 21
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Tie")
    end

    # START TESTING WITH ACE'S
    def test_compare_the_two_part_two7
    	player = Player.new
		dealer = Dealer.new(player)

		dealer.hands << Card.new("A", "Diamonds")
		dealer.hands << Card.new(2, "Kings")
		dealer.hands << Card.new(2, "Spades")
	    dealer.value += 1 + 2 + 2

		player.hands << Card.new(9, "Diamonds")
		player.hands << Card.new(2, "Kings")
		player.hands << Card.new(2, "Spades")
        player.value += 13

	    # Player: 13 / Dealer: 5 or 15
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")

		player.hands << Card.new(6, "Spades")
		player.value += 6

		# Player: 19 / Dealer: 5 or 15
		assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Player")

       	dealer.hands << Card.new(6, "Kings")
       	dealer.value += 6

       	# Player: 19 / Dealer: 11 or 21
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")
    end

    # Same as test above, but this time, it's the player that has the Ace
    def test_compare_the_two_part_two8
    	player = Player.new
		dealer = Dealer.new(dealer)

		player.hands << Card.new("A", "Diamonds")
		player.hands << Card.new(2, "Kings")
		player.hands << Card.new(2, "Spades")
	    player.value += 1 + 2 + 2

		dealer.hands << Card.new(9, "Diamonds")
		dealer.hands << Card.new(2, "Kings")
		dealer.hands << Card.new(2, "Spades")
        dealer.value += 13

	    # Player: 5 or 15 / Dealer: 13
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Player")

		dealer.hands << Card.new(6, "Spades")
		dealer.value += 6

		# Player: 5 or 15 / Dealer: 19
		assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")

       	player.hands << Card.new(6, "Kings")
       	player.value += 6

		# Player: 11 or 21 / Dealer: 19
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Player")
    end

	# Both with Aces
    def test_compare_the_two_part_two9
    	player = Player.new
		dealer = Dealer.new(dealer)

		player.hands << Card.new("A", "Diamonds")
		player.hands << Card.new(2, "Kings")
		player.hands << Card.new(2, "Spades")
	    player.value += 1 + 2 + 2

		dealer.hands << Card.new("A", "Diamonds")
		dealer.hands << Card.new(2, "Kings")
		dealer.hands << Card.new(2, "Spades")
	    dealer.value += 1 + 2 + 2

	    # Player: 5 or 15 / Dealer: 5 or 15
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Tie")

		dealer.hands << Card.new(6, "Spades")
		dealer.value += 6

		# Player: 5 or 15 / Dealer: 11 or 21
		assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")

       	player.hands << Card.new(4, "Kings")
       	player.value += 4

		# Player: 9 or 19 / Dealer: 11 or 21
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Dealer")


       	dealer.hands << Card.new(8, "Spades")
		dealer.value += 8

		# Player: 9 or 19 / Dealer: 19 or 29
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "stand"), "Tie")

    end

    # Test if just hit and busted. Tested during game as well
    def test_compare_the_two_part_two10
    	player = Player.new
		dealer = Dealer.new(dealer)

		player.hands << Card.new(10, "Diamonds")
		player.hands << Card.new(2, "Kings")
		player.hands << Card.new(2, "Spades")
	    player.value += 10 + 2 + 2

		dealer.hands << Card.new(10, "Diamonds")
		dealer.hands << Card.new(2, "Kings")
		dealer.hands << Card.new(10, "Spades")
	    dealer.value += 10 + 2 + 10

	    # Player: 14 / Dealer: 12 + (10 on hit)
       	assert_match(dealer.test_compare_the_two(player, "stand", dealer, "hit"), "Player")
    end

    def test_compare_the_two_part_two11
    	player = Player.new
		dealer = Dealer.new(dealer)

		dealer.hands << Card.new(10, "Diamonds")
		dealer.hands << Card.new(2, "Kings")
		dealer.hands << Card.new(2, "Spades")
	    dealer.value += 10 + 2 + 2

		player.hands << Card.new(10, "Diamonds")
		player.hands << Card.new(2, "Kings")
		player.hands << Card.new(10, "Spades")
	    player.value += 10 + 2 + 10

	    # Player: 12 + (10 on hit) / Dealer: 14
       	assert_match(dealer.test_compare_the_two(player, "hit", dealer, "hit"), "Dealer")
    end
end