#-*- coding: utf-8 -*-#
class Game < ActiveRecord::Base
  Card # need to eager load the Card model

  attr_accessible :num_players, :current_player, :num_decks

  serialize :cards

  has_many :players
  has_one :dealer_hand, :class_name => 'Hand', :foreign_key => 'dealer_id'

  before_save :set_default_attributes, :on => :create

  def set_default_attributes
    case type
    when 'Blackjack'
      self.num_decks = 6 unless self.num_decks
    end
  end

  def get_new_hands
    puts 'get_new_hands' if Rails.env.development?
    new_dealer_hand
    players.each do |player|
      player.hands.map(&:mark_as_played)
      player.get_new_hand
    end
  end

  def new_dealer_hand
    self.dealer_hand.mark_as_played
    self.dealer_hand = Hand.create!(:dealer_id => self.id)
    save!
  end

  def should_deal?
    # check to see if we have at least one player ready to play
    players.map(&:deal_in?).count(true) > 0
  end
end
