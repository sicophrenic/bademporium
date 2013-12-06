#-*- coding: utf-8 -*-#
class ApiController < ApplicationController
  before_action :require_signed_in

  # Blackjack before_actions
  before_action :configure_blackjack_params, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]
  before_action :set_blackjack_game, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]
  before_action :set_blackjack_user, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]
  before_action :verify_user_turn, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]

  def blackjack_hit
  end

  def blackjack_stand
  end

  def blackjack_double
  end

  def blackjack_split
  end

  private
    # Blackjack before_actions
    def set_blackjack_game
      @blackjack = Blackjack.find(params[:blackjack_game_id])
    end
    def set_blackjack_user
      @player = Player.find(params[:player_id])
    end

    def verify_user_turn
      if @blackjack.players[@blackjack.current_player].id != @player.id
        flash[:error] = 'Fuck you, cheater! (Actually, if this is a bug, please report it. Sorry for the vulgarity.)'
        redirect_to blackjack_join_path(@blackjack.id)
      end
    end

    def configure_blackjack_params
      configure_params([:blackjack_game_id, :player_id]) do
        flash[:error] = "Invalid params; #{@missing_params} were not present in the request."
        redirect_to blackjack_join_path(@blackjack.id)
      end
    end
end
