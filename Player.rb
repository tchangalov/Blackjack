# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# 
# CLASS DECRIPTION:
# ==== In blackjack, the player does the following =====
#
#   Holds the cards
#   Likes when there are aces
#   Decides to hit or stand
# 
# This class performs the first two. The third action is
# performed by the dealer. Its most important element
# is arguably the "hands" because it holds all the cards
# contained by each player.

#!/usr/bin/env ruby
$:.unshift("#{File.dirname(__FILE__)}")

require 'ConstantValues'
require 'Card'
require 'Deck'

class Player
    include ConstantValues
    attr_accessor :value, :hands

    def initialize
        @hands = []
        @value = 0
    end

    # Return if card exists. Performs check in begining. 
    # Better readability in dealer class when checking for Ace
    def has_face(face2)
        @hands.each{ |card| if card.face == face2 then return true end}
        return false
    end

    # Used when checking if blackjack occurs at the first dealing of the card
    # (Ace plus any of the 10-valued cards J, Q, K)
    def has_val(val2)
        @hands.each{ |card| if card.value == val2 then return true end}
        return false
    end   

    # Identifies player vs dealer
    def to_s 
        "player"
    end

    # Prints cards in order that they are added to hand
    def hands_to_s
        puts "#{self.to_s}'s cards:"
        @hands.each{ |card| puts card.to_s }
        puts ""
    end
end