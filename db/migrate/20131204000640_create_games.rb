#-*- coding: utf-8 -*-#
class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :type
      t.integer :num_players, :null => false
      t.integer :current_player_idx, :default => 0
      t.integer :num_decks
      t.boolean :should_save_hands, :default => false
      t.text :cards, :default => []

      t.timestamps
    end
  end
end
