#-*- coding: utf-8 -*-#
class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.integer :player_id
      t.integer :dealer_id
      t.string :cards, :default => []
      t.boolean :played, :default => false

      t.timestamps
    end
  end
end
