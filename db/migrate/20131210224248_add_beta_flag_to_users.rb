#-*- coding: utf-8 -*-#
class AddBetaFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :beta, :boolean, :default => false
  end

  def self.down
    remove_column :users, :beta
  end
end
