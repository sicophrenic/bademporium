#-*- coding: utf-8 -*-#
class Player < ActiveRecord::Base
  attr_accessible :user_id, :game_id, :current_hand

  has_many :hands

  belongs_to :user
  belongs_to :game

  # Game methods
  def end_turn?
    current_hand == hands.count - 1
  end

  def my_turn?
    game.current_player_id == id
  end

  def current_hand_id
    if current_hand == hands.count
      return -1
    else
      return current_hand_obj.id
    end
  end

  def current_hand_obj
    hands[current_hand]
  end

  def next_hand
    self.current_hand += 1
    self.save!
  end

  def split_hand
    to_split = current_hand_obj
    hands.delete(current_hand_obj)
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
    game.check_for_blackjack
    game.dealer_move if game.dealer_move?
  end

  def reset
    update_attribute(:current_hand, 0)
  end

  def to_firebase_hash
    player_hash = {
      :player_id => id
    }
    player_hash[:hands] = hands.map(&:to_firebase_hash) if deal_in?
    return player_hash
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
