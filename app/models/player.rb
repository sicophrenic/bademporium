#-*- coding: utf-8 -*-#
class Player < ActiveRecord::Base
  attr_accessible :user_id, :game_id, :current_hand_idx

  has_many :hands

  belongs_to :user
  belongs_to :game

  # Game methods
  def end_turn?
    current_hand_idx == hands.count - 1
  end

  def my_turn?
    game.current_player_id == id
  end

  def to_next_hand
    current_hand.mark_as_played
    self.current_hand_idx += 1
    self.save!
  end

  def split_hand
    to_split = current_hand
    hands.delete(current_hand)
    new_hands = []
    to_split.cards.each do |c|
      new_hand = Hand.create!
      new_hand.player = self
      new_hand.cards << game.draw
      new_hand.save!
      new_hands << new_hand
    end
    new_hands.each do |h|
      h.cards << game.draw
      h.save!
    end
    self.hands += new_hands
    save!
  end

  def reset_current_hand
    update_attribute(:current_hand_idx, 0)
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

  # Helper methods
  def current_hand
    if current_hand_idx == hands.count
      return nil
    else
      return hands[current_hand_idx]
    end
  end

  def current_hand_id
    if current_hand.nil?
      return -1
    else
      return current_hand.id
    end
  end
end
