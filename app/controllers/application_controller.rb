#-*- coding: utf-8 -*-#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_signed_in
    if !user_signed_in?
      flash[:error] = 'You must be signed in to do that.'
      redirect_to root_path
    end
  end
end
