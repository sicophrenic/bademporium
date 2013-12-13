#-*- coding: utf-8 -*-#
class CreateDeployServices < ActiveRecord::Migration
  def self.up
    create_table :deploy_services do |t|
      t.string :name, :null => false
      t.boolean :enabled_for_beta, :default => false
      t.boolean :enabled_for_everyone, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :deploy_services
  end
end
