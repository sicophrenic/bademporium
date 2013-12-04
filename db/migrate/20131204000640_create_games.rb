#-*- coding: utf-8 -*-#
class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :type
      t.integer :num_players
      t.integer :current_player, :default => 0
      t.integer :num_decks
      t.string :cards, :default => []

      t.timestamps
    end
  end
end
