#-*- coding: utf-8 -*-#
class Player < ActiveRecord::Base
  attr_accessible :user_id, :game_id, :hand_id

  has_many :hands

  belongs_to :user
  belongs_to :game

  # Game methods
  def end_turn?
    hand_id == hands.count - 1
  end

  def current_hand
    hands[hand_id]
  end

  def next_hand
    self.hand_id += 1
    self.save!
  end

  # Pre-game methods
  def deal_me_in
    update_attribute(:deal_in, true)
  end

  def deal_me_out
    update_attribute(:deal_in, false)
  end

  def get_new_hand
    self.hands = [Hand.create!(:player_id => id)]
    save!
  end
end
