#-*- coding: utf-8 -*-#
class DeployServicesController < ApplicationController
  before_action :set_deploy_service
  before_action :require_admin

  def disable
    @deploy_service.disable_for_everyone
    redirect_to deploy_services_path
  end

  def enable_for_everyone
    @deploy_service.enable_for_everyone
    redirect_to deploy_services_path
  end

  def enable_for_beta
    @deploy_service.enable_for_beta
    redirect_to deploy_services_path
  end

  private
    def set_deploy_service
      @deploy_service = DeployService.find(params[:id])
    end
end
