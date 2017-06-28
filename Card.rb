# Author::    Ivelin Tchangalov  (mailto:i.tchangalov@gmail.com)
# Copyright:: Copyright (c) 2016 Ivelin Tchangalov
# License::   Creative Commons Attribution 4.0 International
# 
# CLASS DECRIPTION:
# This class creates the cards by assigning values to faces.

#!/usr/bin/env ruby
$:.unshift("#{File.dirname(__FILE__)}")

require 'ConstantValues'

class Card
    include ConstantValues
    attr_accessor :value, :face, :suit
    attr_reader :is_ace

    def initialize(face, suit)
        @face = face
        @suit = suit
        @is_ace = false

        # All cards count as their face value, 
        # except A which can be 1 or 11 and 
        # J, Q, K all count as 10
        case face
        when 2..10
            @value = face
        when "J"
            @value = 10
        when "Q"
            @value = 10
        when "K"
            @value = 10
        when "A"
            @is_ace = true

            @value = 1
        else
            ArgumentError.new("Something is wrong with creaing deck")
        end
    end  

    def to_s
        "#{@face} of #{@suit}"
    end
end