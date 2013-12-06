#-*- coding: utf-8 -*-#
class Card < ActiveRecord::Base
  attr_accessible :value, :suit

  VALUES = %w[ 2 3 4 5 6 7 8 9 10 J Q K A ]
  INT_VALUES = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10,
    'A' => 11
  }
  SUITS = {
    'S' => 'Spade',
    'H' => 'Heart',
    'D' => 'Diamond',
    'C' => 'Club'
  }

  def to_int_value
    INT_VALUES[value]
  end

  def to_s
    "#{value} of #{SUITS[suit].pluralize}"
  end
end
