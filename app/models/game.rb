#-*- coding: utf-8 -*-#
class Game < ActiveRecord::Base
  attr_accessible :num_players, :current_player, :num_decks

  serialize :cards

  before_save :set_default_attributes

  def set_default_attributes
    case type
    when 'Blackjack'
      self.num_decks = 6 unless self.num_decks
    end
  end
end
