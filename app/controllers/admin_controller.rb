#-*- coding: utf-8 -*-#
class AdminController < ApplicationController
  before_action :require_admin

  def index
  end

  def deploy_services
    @deploy_services = DeployService.all.order('name asc')
  end
end
