# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# MODULE DESCRIPTION
# === Defines constantValues for the game ===
# Includes
#     - Value for when dealer stands
#     - Arrays representing suits and values
#     - Blackjack winning value
#     - commands representing when to Stand -- Deleted (see attr_reader in Dealer)

#!/usr/bin/env ruby
module ConstantValues
	# Constants pertaining to game
    DECK_SUITS = ["Spades", "Diamonds", "Clubs", "Hearts"]
    DECK_FACE = ["J", "Q", "K", "A", 2, 3, 4, 5, 6, 7, 8, 9, 10]

    # Constants pertaining to dealer and game
    D_STANDS = 17
    G_BLACKJACK = 21
end
