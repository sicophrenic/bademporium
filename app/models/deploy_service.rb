#-*- coding: utf-8 -*-#
class DeployService < ActiveRecord::Base
  attr_accessible :name, :enabled_for_beta, :enabled_for_everyone

  def enabled_for_user?(user)
    if enabled_for_everyone || (enabled_for_beta && user.beta?)
      return true
    else
      return false
    end
  end

  def self.enabled_for_user?(user, name)
    DeployService.find_by(:name => name).enabled_for_user?(user)
  end

  def enable_for_everyone
    update_attribute(:enabled_for_beta, true)
    update_attribute(:enabled_for_everyone, true)
  end

  def disable_for_everyone
    update_attribute(:enabled_for_beta, false)
    update_attribute(:enabled_for_everyone, false)
  end

  def enable_for_beta
    update_attribute(:enabled_for_beta, true)
    update_attribute(:enabled_for_everyone, false)
  end
end
