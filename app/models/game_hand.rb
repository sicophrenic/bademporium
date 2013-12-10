#-*- coding: utf-8 -*-#
class GameHand < ActiveRecord::Base
  attr_accessible :game_type, :hand_ids, :dealer_hand_id

  serialize :hand_ids

  def dealer_hand
    Hand.find(dealer_hand_id)
  end

  def self.create_from_game(game)
    puts "Creating GameHand for a #{game.type} game." if Rails.env.development?
    case game.type
    when 'Blackjack'
      record = GameHand.new(
        :game_type => 'Blackjack',
        :dealer_hand_id => game.dealer_hand.id)
      record.hand_ids = []
      game.players.each do |p|
        p.hands.each do |h|
          record.hand_ids << h.id
        end
      end
      record.save!
    end
  end
end
