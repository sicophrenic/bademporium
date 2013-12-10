#-*- coding: utf-8 -*-#
class CreateGameHands < ActiveRecord::Migration
  def self.up
    create_table :game_hands do |t|
      t.string :game_type, :null => false
      t.string :hand_ids, :null => false
      t.integer :dealer_hand_id, :null => false

      t.timestamps
    end
    add_index :game_hands, :game_type
  end

  def self.down
    drop_table :game_hands
  end
end
