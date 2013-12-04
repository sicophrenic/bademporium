#-*- coding: utf-8 -*-#
class CreateBlackjacks < ActiveRecord::Migration
  def change
    create_table :blackjacks do |t|

      t.timestamps
    end
  end
end
