#-*- coding: utf-8 -*-#
class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id, :null => false
      t.integer :game_id, :null => false
      t.integer :current_hand_idx, :default => 0, :null => false
      t.boolean :deal_in, :default => false

      t.timestamps
    end
  end
end
