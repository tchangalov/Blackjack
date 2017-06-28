# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# CLASS DECRIPTION:
# ===Class creates instance of deck with 52 cards.
# Mainly defines dealing a card and shuffling*. 

#!/usr/bin/env ruby

require 'Card'

class Deck
    include ConstantValues
    attr_accessor :Deck_myDeck
    # Assumption: We only need one deck per game so we don't recreate if cards run out
    # Initialize Deck by creating it

    def initialize
        @Deck_myDeck =
            DECK_FACE.map{|f|
                DECK_SUITS.map{|s|
                    Card.new(f, s)
                }
        }

        # The deck will be shuffled before each game
        @Deck_myDeck.flatten!
    end

    # For security, if the user knows Ruby, they could backtrace the given "shuffle" method
    # The user could easily predict what the next card would be if they know how shuffle was built
    # This adds a layer of protection against that by adding a sort of hashCode for shuffling
    # IN EFFECT: Shuffles the deck between a more random number of times (between 1-75) 
    def my_shuffle!
        num = Random.new
        # Ensures at least 1 shuffle occurs
        num = (num.rand(15000) % 74) + 1
        num.times{@Deck_myDeck.shuffle!}
    end

    # take one off deck
    def deal
        @Deck_myDeck.pop
    end

    def length
        @Deck_myDeck.length
    end

    # Not really used for anything
    def to_s
        @Deck_myDeck.each{|card| puts card.to_s}
    end
end