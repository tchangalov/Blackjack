# The program takes creates a deck of cards and two players.
# It plays a simple game of blackjack. The dealer is controlled by this 
# program. The player is controlled by a user on command line.
# 
# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# CLASS DECRIPTION:
# This class is essentially the driver class for the program.
# Most of the processing occurs in Dealer, who creates an instance of
# The deck and distributes between himself and the other player.

# Line below taken from http://www.rubydoc.info/gems/ocra/1.1.2
# The line lets you require additional source files
# in the directory that the current user is working in.

#!/usr/bin/env ruby
$:.unshift("#{File.dirname(__FILE__)}")

require 'Dealer'
require 'Player'
require 'Card'
require 'Deck'
require 'ConstantValues'

def start
    # Create mix-in of constant's module
    include ConstantValues

    player = Player.new
    dealer = (Dealer.new(player)).setup_game
end

# Asks if user wants to play again, if so, destroy objects and start again
def play_again
    loop do
        choice = prompt_new_game
        if choice == "y" then
            player = nil
            dealer = nil
            new_game
        else
            exit
        end
    end
end

# Prompts for new game, stores answer
def prompt_new_game
    puts ""
    puts "Do you want to play again? (y)"
    puts "Press any other key to exit"
    return gets.chomp
end

# Printing helper for organization
def new_game
    # Start again!
    puts "\n\n"
	
	# Clears output from last game
    Gem.win_platform? ? (system "cls") : (system "clear")
    
    puts "Beginning new game:"
    puts ""
    start
end

# THIS IS THE FIRST CALL INTO THE PROGRAM
start
# If the game ends, ask to play again
play_again
