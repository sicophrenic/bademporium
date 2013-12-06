#-*- coding: utf-8 -*-#
class Card < ActiveRecord::Base
  attr_accessible :value, :suit

  VALUES = %w[ 2 3 4 5 6 7 8 9 10 J Q K A ]
  SUITS = {
    'S' => 'Spade',
    'H' => 'Heart',
    'D' => 'Diamond',
    'C' => 'Club'
  }

  def to_s
    "#{self.value} of #{SUITS[self.suit].pluralize}"
  end
end
