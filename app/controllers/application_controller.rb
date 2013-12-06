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

  def can_join_game?(game)
    return game.players.count < game.num_players
  end

  def configure_params(required, optional = {})
    @missing_params = []
    required.each do |param|
      if !param.in?(params.keys)
        @missing_params << required
      end
    end
    if !@missing_params.empty?
      yield
    else
      optional.each do |to_do, param_keys|
        case to_do
        when 'boolify'
          param_keys.each do |key|
            if params[key].in?(1, true, '1', 'true')
              params[key] = true
            elsif params[key].in?(0, false, '0', 'false')
              params[key] = false
            end
          end
        end
      end
    end
  end
end
