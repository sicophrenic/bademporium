#-*- coding: utf-8 -*-#
class Hand < ActiveRecord::Base
  attr_accessible :player_id, :dealer_id

  belongs_to :player
  belongs_to :game, :foreign_key => 'dealer_id'

  serialize :cards

  validate :exclusive_hand

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
        points -= 10
      end
    end
    if Rails.env.development? && debug
      puts "[debug-hand.value] -- #{cards.map(&:value)} = #{points}"
    end
    points
  end

  def finish
    update_attribute(:played, true)
  end

  def to_s
    "#{cards.map(&:to_s).join(', ')} == #{value(false)}"
  end

  private
    def exclusive_hand
      if player_id && dealer_id
        errors.add(:exclusive, 'cannot be a player hand AND a dealer hand.')
      end
    end
end
