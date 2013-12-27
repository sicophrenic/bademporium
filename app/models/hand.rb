#-*- coding: utf-8 -*-#
class Hand < ActiveRecord::Base
  attr_accessible :player_id, :dealer_id, :played

  belongs_to :player
  belongs_to :game, :foreign_key => 'dealer_id'

  serialize :cards

  validate :exclusive_hand

  SPLIT_CARDS = [Card.find(7), Card.find(20)]
  BLACKJACK_CARDS = [Card.find(9), Card.find(13)]
  ACTIONS = [:hit, :stand, :double, :split]

  # Method: splits current hand and returns two new hands
  def split
  end

  # Method: calculate the value of a hand
  # Parameters:
  #   points_only
  #   debug - when set to true, print out hand value along with which cards are in hand
  #         - set to false when printing out hand (to_s) because we don't want all that extra logging to show up
  def value(opts = {:points_only => true})
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
    if Rails.env.development? && opts[:debug]
      puts "[debug-hand.value] -- #{cards.map(&:value)} = #{points}"
    end
    if opts[:points_only]
      return points
    elsif opts[:soft_only]
      return seen_ace
    elsif opts[:points_and_soft]
      return points, seen_ace
    end
  end

  def soft?
    value({:soft_only => true})
  end

  def bust?
    value > 21
  end

  def blackjack?
    value == 21 && cards.count == 2
  end

  def win_lose_push(target = nil)
    target = player.game.dealer_hand.value if target.nil?
    if value > 21
      # player bust
      'lose'
    elsif target > 21
      # dealer bust
      'win'
    elsif value < target
      # player less than dealer
      'lose'
    elsif value == target
      # player equal dealer
      'push'
    elsif value > target
      # player beat dealer
      'win'
    end
  end

  def available_actions
    available = ACTIONS.dup
    available.delete(:double) unless can_double?
    available.delete(:split) unless can_split?
    return available
  end

  def can_double?
    cards.count == 2
  end

  def can_split?
    cards.count == 2 && cards.map(&:to_int_value).count(cards.first.to_int_value) == 2
  end

  def mark_as_played
    update_attribute(:played, true)
  end

  def to_s(imgs = false)
    if cards.empty?
      '[] == 0'
    else
      "#{cards.map(&:to_s).join(', ')} == #{value(:points_only => true)}"
    end
  end

  def dealer_showing(imgs = false)
    if cards.empty?
      to_s
    elsif imgs
      "#{cards.last.to_img_s}"
    else
      "#{cards.last.to_s}"
    end
  end

  def to_firebase_hash(options = {})
    dealer_value = player.game.dealer_hand.value if player
    reveal = options.delete(:dealer)
    if reveal || reveal.nil?
      # should reveal dealer or regular player hand
      firebase_hash = {
        :hand_id => id,
        :cards => cards.map(&:to_img_s),
        :value => value,
        :actions => available_actions
      }
      firebase_hash[:result] = win_lose_push(dealer_value) if player && player.game.game_played?
      return firebase_hash
    elsif !reveal
      return {
        :hand_id => id,
        :cards => [dealer_showing(true)]
      }
    end
  end

  def empty?
    cards.empty?
  end

  def current_game_hand?
    self == player.current_hand && player == player.game.current_player
  end

  private
    def exclusive_hand
      if player_id && dealer_id
        errors.add(:exclusive, 'cannot be a player hand AND a dealer hand.')
      end
    end
end
