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
    current_hand.mark_as_played

    first_card = current_hand.cards.first
    second_card = current_hand.cards.last

    hands.delete(current_hand)

    first_hand = hands.build
    second_hand = hands.build

    first_hand.cards << first_card
    first_hand.cards << game.draw

    second_hand.cards << second_card
    second_hand.cards << game.draw

    save!
  end

  def reset_current_hand
    update_attribute(:current_hand_idx, 0)
  end

  def to_firebase_hash
    player_hash = {
      :player_id => id
    }
    player_hash[:hands] = hands.map(&:to_firebase_hash) if deal_in?
    return player_hash
  end

  def to_s
    print_hands = hands.map(&:to_s)
    print = []
    print_hands.each_with_index do |h, i|
      print << "<div id=\"player_#{id}_hand_#{i}\">#{h}</div>"
    end
    return print.join("\n");
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
