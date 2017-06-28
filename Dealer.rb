# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# CLASS DECRIPTION:
# ==== In blackjack, the dealer controls the game =====
#
#   Brings cards to table (creates instance of deck)
#   Shuffles cards
#   Deals cards
#   keeps track of players
#   Determines winner
# 
# This class does just that. The dealer is-a player
# Thus, the object is an extension of "player".
# 
# === This class is split up into a few components: ===
# 
#   1.Game initialize and set-up
#   2.Methods used to deal cards
#   3.Prompting user to decide
#   4.Computing Dealer's next move 
#   5.Comparing values
#   6.Finally, printing methods used for debugging

#!/usr/bin/env ruby
$:.unshift("#{File.dirname(__FILE__)}")

require 'ConstantValues'
require 'Card'
require 'Deck'
require 'Player'

# Inherets and extends from player
class Dealer < Player
    attr_accessor :deck, :player, :game_start, :game_over
    attr_reader :MOVES
    include ConstantValues
    def initialize(player)
        # Hash table of moves for readability
        @MOVES = {"h"=>"hit", "s"=>"stand"}
        @player = player
        @hands = []
        @value = 0
        @deck = Deck.new

        # Controls game
        @game_start = true
        @game_over = false
    end

#################### GAME SET UP ##########################
    # The players are each dealt 2 cards to start the hand
    # custom shuffle before starting the game
    def setup_game
        if (@game_start == true) then
            deck.my_shuffle!
            2.times{deal(@player)}
            2.times{deal(self)}
            @game_start = false

            # show_both_hands(@player, self)

            # If either player has 21 with their first two cards, 
            # they win (unless they both have 21 on their first
            # two cards, in which case it is a tie)

            # Blackjack occurs only if there is an Ace and one of (J, Q, K, 10)
            d_has_blackjack = self.has_face("A") && self.has_val(10)
            p_has_blackjack = @player.has_face("A") && @player.has_val(10)


            if d_has_blackjack && p_has_blackjack then
                end_game_w_msg("Blackjack Tie in first two cards!")

            elsif d_has_blackjack then
                end_game_w_msg("Dealer got blackjack with two cards!")

            elsif p_has_blackjack then
                end_game_w_msg("Player got blackjack with two cards!")
            end
        end
        self.begin
    end

#################### GAME LOOPS ##########################

    # Loops if game is not over.
    # Checks if game ended during set up
    # Otherwise loops
    def begin
        while @game_over == false
            break if (@game_over)
            play
        end
    end

    def play
        # Player goes first. Decide if hit or stand
        player_move = let_player_decide(@player, @player.hands)

        # Compute dealer move based on his hand (accounting for Ace's)
        dealer_move = compute_dealer_move(self, self.hands)
        puts ""
        # Prints what move each person made
        puts "player move: #{player_move}"      
        puts ""  
        puts "dealer move: #{dealer_move}\n"
        puts ""
        # Uses move decision to either deal or stand
        deal(self) unless dealer_move == "stand"

        # Decision maker
        compare_the_two(@player, player_move, self, dealer_move)
    end


################## Dealing Methods ########################
    # Push card to hand and update lowest value
    def deal(player)
        card = @deck.deal
        player.hands << card
        player.value += card.value
    end

############# Player: Prompt for hit or stand #############
    # Shows player's current cards, prompts to hit or stand,
    # Deals a card to player if he chose hit. Stores the move
    # As a return
    def let_player_decide(player, the_hand)
        p_choice = ""

        puts "Here are your cards:\n"
        show_hands(@player)

        loop do
            puts "Hit or Stand? 'h' or 's'. Press 'x' to exit"
            p_choice = gets.chomp

            if p_choice == "x" then
                exit
            end

            break if(p_choice == "h" || p_choice == "s") 
            puts "Sorry, try again\n\n"
        end

        if p_choice == "h" then
            deal(@player)
            return @MOVES["h"]
        else
            return @MOVES["s"]
        end
    end

############# Dealer: Compute next move ###################
    def compute_dealer_move(player, the_hand)
        # If there are no Ace's in the hand, then the decision is simple
        if !player.has_face("A") then

            # If value is less than 17, then hit, otherwise stand
            if player.value < D_STANDS then 
                return @MOVES["h"]
            else
                return @MOVES["s"]
            end
        # If there is one or more ace
        elsif(player.has_face("A")) then
            # One Ace is just 10 up since default is 1 (value: 11)
            lowest = player.value
            highest = player.value + 10

            # It means dealer busted. Comper_the_two method calls him out on that
            if (lowest > G_BLACKJACK) then
                return @MOVES["s"]

            # Did this part using a "truth table". The lowest value is where Ace is 1
            # Highest value is where Ace is 11, which means lowest + 10 = highest
            # If lowest is on stands, then stand. If highest is on stands then stand
            elsif (lowest >= D_STANDS) || (lowest < D_STANDS && highest >= D_STANDS && highest <= G_BLACKJACK) then 
                return @MOVES["s"] 

            # If lowest yields a hit, then he should hit regardless of if highest is on bust
            # Previous case takes care of if the Ace passes Standing threshold
            elsif (lowest < D_STANDS) then 
                return @MOVES["h"] 
            end
            # Shouldn't get to here
            return @MOVES["s"]
        end
    end
    
############# Compare: Decide winner ######################
    # The bulk of the decision making for the game.
    # STEPS:
    # (1) Performs low-value and checks if busting
    # (2) Sees that either: both players stand, or one player hit and busted
    # (3) If (2) happens, check if busting occurs.
    # (4) Find highest value of one or both have an Ace 
    #           *Checks that Ace doesn't go over winning value before passing in
    # (5) Use generic comparison method to compare the values
    # (6) If no Aces, then perform the generic comparison using lowest values

    def compare_the_two(player, player_move, dealer, dealer_move)
        # If both players bust, the dealer wins
        if (player.value > G_BLACKJACK) && (dealer.value > G_BLACKJACK) then
            end_game_w_msg("Dealer wins by default because you both busted!")
            return
        end

        if (player.value <= G_BLACKJACK) && (dealer.value > G_BLACKJACK) then
            end_game_w_msg("Player wins because dealer busted!")
            return
        end

        if (dealer.value <= G_BLACKJACK) && (player.value > G_BLACKJACK) then
            end_game_w_msg("Dealer wins because player busted!")
            return
        end

        # If they are both on "stand" OR one of the could have busted on hit
        # So this is where we check for that as well
        if (player_move == @MOVES["s"] && dealer_move == @MOVES["s"] || 
            (player_move == @MOVES["h"] && player.value > G_BLACKJACK) || 
            (dealer_move == @MOVES["h"] && dealer.value > G_BLACKJACK)) then

            # Check these again just in case
            if (player.value > G_BLACKJACK) then
                end_game_w_msg("Dealer wins because you busted!")
                return

            elsif (dealer.value > G_BLACKJACK) then
                end_game_w_msg("Player wins because dealer busted!")
                return
            end

            # Part (4) of description: PROCESS IF ANY ACES
            if player.has_face("A") || dealer.has_face("A") then

                player_low = player.value
                dealer_low = dealer.value
                player_high = player.value + 10
                dealer_high = dealer.value + 10

                # Module for comparing points when players have Ace's
                # both have an Ace
                if (dealer.has_face("A") && player.has_face("A") &&
                    dealer_high <= G_BLACKJACK && player_high <= G_BLACKJACK) then
                    generic_compare(player, player_high, dealer, dealer_high)
                    return

                # Dealer has an Ace, Player Doesn't
                elsif(dealer.has_face("A") && dealer_high <= G_BLACKJACK) then
                    generic_compare(player, player_low, dealer, dealer_high)
                    return

                # Player has an Ace, Dealer Doesn't
                elsif(player.has_face("A") && player_high <= G_BLACKJACK) then
                    generic_compare(player, player_high, dealer, dealer_low)
                    return
                end
            end

            # CONTINUE IF ALL ACES HAVE BEEN TRIED
            # Perform generic comparison 
            generic_compare(player, player.value, dealer, dealer.value)
            return
        end
    end

    # This method is used in conjunction with method above
    def generic_compare(player, player_val, dealer, dealer_val)
        # If both players have the same score, they tie
        if(player_val == dealer_val) then
            if(player_val == G_BLACKJACK) then
                end_game_w_msg("Tie because you both got blackjack!")
            else
                end_game_w_msg("Tie because you both ended with the same score!")
            end

        # Player got blackjack
        elsif (player_val == G_BLACKJACK) then
            end_game_w_msg("Player wins because you got blackjack!")

        # Dealer got blackjack
        elsif(dealer_val == G_BLACKJACK) then
            end_game_w_msg("Dealer wins because he got blackjack!")

        # Dealer had higher value and player doesn't have Ace's
        elsif(dealer_val > player_val && dealer_val < G_BLACKJACK) then
            end_game_w_msg("Dealer wins with higher points!")

        # Player had higher value and dealer doesn't have Ace's
        elsif(player_val > dealer_val && player_val < G_BLACKJACK) then
            end_game_w_msg("Player wins with higher points!")
        end
    end

############# String/Printing Methods #####################
    # Makes game stop and prints 
    def end_game_w_msg(msg)
        @game_over = true
        puts msg
        puts "These were the cards in play:"
        show_both_hands(self, @player)
    end

    def show_hands(player)
        player.hands_to_s
    end

    def show_both_hands(player, dealer)
        player.hands_to_s
        dealer.hands_to_s
    end

    def to_s
        "dealer"
    end

# END OF FUNCTIONAL CODE.





##################### METHODS FOR TESTING!!! #########################
# The difference with these classes is the return
# I will only return the winner as a string instead
# of printing reasons 
# I couldn't think of another way to test it since the original
# methods print out the winner and reset game. So I manually changed 
# return statements (return generic test instead of printing stuff)
#######################################################################

def test_compare_the_two(player, player_move, dealer, dealer_move)
        # If both players bust, the dealer wins
        if (player.value > G_BLACKJACK) && (dealer.value > G_BLACKJACK) then
            return "Dealer"
        end

        if (player.value <= G_BLACKJACK) && (dealer.value > G_BLACKJACK) then
            return "Player"
        end

        if (dealer.value <= G_BLACKJACK) && (player.value > G_BLACKJACK) then
            return "Dealer"
        end

        # If they are both on "stand" then one of the could have busted
        # So this is where we check for that as well
        if (player_move == @MOVES["s"] && dealer_move == @MOVES["s"] || 
            (player_move == @MOVES["h"] && player.value > G_BLACKJACK) || 
            (dealer_move == @MOVES["h"] && dealer.value > G_BLACKJACK)) then

            # First we want to check if anyone busted before looking at Ace values:
            # Player busted with lowest values
            if (player.value > G_BLACKJACK) then
                return "Dealer"

            # Dealer busted
            elsif (dealer.value > G_BLACKJACK) then 
                return "Player"
            end

            # Part (4) of description: PROCESS IF ANY ACES
            if player.has_face("A") || dealer.has_face("A") then
                player_low = player.value
                dealer_low = dealer.value
                player_high = player.value + 10
                dealer_high = dealer.value + 10

                # Module for comparing points when players have Ace's
                # both have an Ace
                if (dealer.has_face("A") && player.has_face("A") &&
                    dealer_high <= G_BLACKJACK && player_high <= G_BLACKJACK) then
                    return test_generic_compare(player, player_high, dealer, dealer_high)

                # Dealer has an Ace, Player Doesn't
                elsif(dealer.has_face("A") && dealer_high <= G_BLACKJACK) then
                    return test_generic_compare(player, player_low, dealer, dealer_high)

                # Player has an Ace, Dealer Doesn't
                elsif(player.has_face("A") && player_high <= G_BLACKJACK) then
                    return test_generic_compare(player, player_high, dealer, dealer_low)
                end
            end

            # CONTINUE IF ALL ACES HAVE BEEN TRIED
            # Perform generic comparison 
            return test_generic_compare(player, player.value, dealer, dealer.value)
        end
    end

    # This method is used in conjunction with method above
    def test_generic_compare(player, player_val, dealer, dealer_val)
        # If both players have the same score, they tie
        if(player_val == dealer_val) then
            if(player_val == G_BLACKJACK) then
                return "Tie"
            else
                return "Tie"
            end

        # Player got blackjack
        elsif (player_val == G_BLACKJACK) then
            return "Player"

        # Dealer got blackjack
        elsif(dealer_val == G_BLACKJACK) then
            return "Dealer"

        # Dealer had higher value and player doesn't have Ace's
        elsif (dealer_val > player_val) && (dealer_val < G_BLACKJACK) then

            return "Dealer"

        # Player had higher value and dealer doesn't have Ace's
        elsif (player_val > dealer_val) && (player_val < G_BLACKJACK) then
            return "Player"
        end
    end
end
