#-*- coding: utf-8 -*-#
class Game < ActiveRecord::Base
  Card # need to eager load the Card model

  attr_accessible :num_players, :current_player, :num_decks, :should_save_hands

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

  def get_new_hands(save_hands = false)
    if save_hands
      GameHand.create_from_game(self)
    end

    puts 'get_new_hands' if Rails.env.development?
    new_dealer_hand
    players.each do |player|
      player.hands.map(&:mark_as_played)
      player.get_new_hand
    end
  end

  def new_dealer_hand
    dealer_hand.mark_as_played if dealer_hand
    self.dealer_hand = Hand.create!(:dealer_id => id)
    save!
  end

  def should_deal?
    # check to see if we have at least one player ready to play
    players.map(&:deal_in?).count(true) > 0
  end

  def shuffle
    bad_cards = self.cards # try to get db logs as quiet as possible
    11.times do
      (0..bad_cards.count-1).each do |idx|
        current_card = bad_cards[idx]
        rnd_idx = rand(bad_cards.count)
        bad_cards[idx] = bad_cards[rnd_idx]
        bad_cards[rnd_idx] = current_card
      end
    end
    self.cards = bad_cards
    self.save!
  end

  # TODO - long term should have a set of processes that ONLY do shuffling of cards
  # so that whenever new cards are needed, just take the first in the list
  def set_up_cards
    puts 'set_up_cards' if Rails.env.development?
    bad_cards = []
    self.num_decks.times do
      Card.all.each do |card|
        bad_cards << card.id
      end
    end
    self.cards = bad_cards
    self.save! # try to get db logs as quiet as possible
    shuffle
  end
end
