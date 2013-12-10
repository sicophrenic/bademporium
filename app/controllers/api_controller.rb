#-*- coding: utf-8 -*-#
class ApiController < ApplicationController
  before_action :require_signed_in

  # Blackjack before_actions
  before_action :configure_blackjack_params, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]
  before_action :set_blackjack_game, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]
  before_action :set_blackjack_user, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]
  before_action :set_player_hand, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]
  before_action :verify_action, :only => [:blackjack_hit, :blackjack_stand, :blackjack_double, :blackjack_split]

  # Blackjack actions
  def blackjack_hit
    @action = 'hit'
    @card = @blackjack.draw
    @hand.cards << @card
    @hand.save

    # if player has busted, end hand
    if @hand.bust? || @hand.value == 21
      @hand.mark_as_played
      # move on to next hand or next player
      if @player.end_turn?
        @blackjack.next_player
      else
        @player.next_hand
      end
    end
    render 'blackjack/game'
  end

  def blackjack_stand
    @action = 'stand'
    @hand.mark_as_played

    # move on to next hand or next player
    if @player.end_turn?
      @blackjack.next_player
    else
      @player.next_hand
    end
    render 'blackjack/game'
  end

  def blackjack_double
    @action = 'double'
    @card = @blackjack.draw
    @hand.cards << @card
    @hand.save
    @hand.mark_as_played

    # only get one card for double
    if @player.end_turn?
      @blackjack.next_player
    else
      @player.next_hand
    end
    render 'blackjack/game'
  end

  def blackjack_split
    @action = 'split'
    if @hand.can_split?
      @player.split_hand
    end
    render 'blackjack/game'
  end

  private
    # Blackjack before_actions
    def set_blackjack_game
      @blackjack = Blackjack.find(params[:blackjack_game_id])
    end
    def set_blackjack_user
      @player = Player.find(params[:player_id])
    end
    def set_player_hand
      @hand = Hand.find(params[:hand_id])
    end

    def verify_action
      if @blackjack.current_player_id != @player.id || !@hand.id.in?(@player.hands.map(&:id))
        flash[:error] = 'Fuck you, cheater! (Actually, if this is a bug, please report it. Sorry for the vulgarity.)'
        redirect_to blackjack_join_path(@blackjack.id)
      end
    end

    def configure_blackjack_params
      configure_params([:blackjack_game_id, :player_id, :hand_id]) do
        flash[:error] = "Invalid params; #{@missing_params} were not present in the request."
        redirect_to blackjack_find_path
      end
    end
end
