#-*- coding: utf-8 -*-#
class Hand < ActiveRecord::Base
  attr_accessible :player_id, :dealer_id, :played

  belongs_to :player
  belongs_to :game, :foreign_key => 'dealer_id'

  serialize :cards

  validate :exclusive_hand

  # Method: calculate the value of a hand
  # Parameters:
  #   debug - when set to true, print out hand value along with which cards are in hand
  #         - set to false when printing out hand (to_s) because we don't want all that extra logging to show up
  def value(debug = true)
    points = 0
    seen_ace = false
    cards.each do |card|
      if card.value == 'A'
        if seen_ace
          points += 1
        else
          seen_ace = true
          points += 11
        end
      elsif card.value.in?(['J', 'Q', 'K'])
        points += 10
      else
        points += card.value.to_i
      end
      if seen_ace && points > 21
        seen_ace = false
        points -= 10
      end
    end
    if Rails.env.development? && debug
      puts "[debug-hand.value] -- #{cards.map(&:value)} = #{points}"
    end
    return points, seen_ace
  end

  def soft?
    total_value, ace_counter = value
    return ace_counter
  end

  def bust?
    total_value, ace_counter = value
    return total_value > 21
  end

  def can_split?
    cards.count == 2 && cards.map(&:to_int_value).count(cards.first.to_int_value) == 2
  end

  def mark_as_played
    update_attribute(:played, true)
  end

  def to_s
    if cards.empty?
      '[] == 0'
    else
      total, soft = value(false)
      "#{cards.map(&:to_s).join(', ')} == #{total}, soft? #{soft}"
    end
  end

  def empty?
    cards.empty?
  end

  private
    def exclusive_hand
      if player_id && dealer_id
        errors.add(:exclusive, 'cannot be a player hand AND a dealer hand.')
      end
    end
end
