#-*- coding: utf-8 -*-#
class BlackjackController < ApplicationController
  include FirebaseHelper

  before_action :require_signed_in
  before_action :set_blackjack, :only => [:join_game, :destroy_game, :ready_up, :game_start, :redeal]
  after_action :update_firebase, :only => [:join_game, :ready_up, :game_start, :redeal]

  def find_game
    @games = Blackjack.all # .where(:privacy => 'public')
  end

  def new_game
  end

  def create_game
    blackjack = Blackjack.create!(params[:blackjack_options])
    push_blackjack_to_firebase(blackjack)
    redirect_to blackjack_join_path(blackjack.id)
  end

  def destroy_game
    remove_blackjack_from_firebase(@blackjack)
    @blackjack.destroy
    redirect_to blackjack_find_path
  end

  def join_game
    # check to see if the player is re-joining a game
    @player = current_user.players.where(:game_id => @blackjack.id).take
    if @player.nil? && can_join_game?(@blackjack)
      # if the game isn't full and the current user doesn't have a player in this game, create the player
      puts "join_game: creating new player for user #{current_user.id}" if Rails.env.development?
      @player = current_user.players.build
      @player.game = @blackjack
      @player.save!
    elsif @player.nil? && @blackjack.players.count == @blackjack.num_players
      # if the game is full and the user isn't already in it, start over
      flash[:error] = 'Sorry, that game is full.'
      redirect_to blackjack_find_path
      return
    end
    @hand = @player.current_hand_obj
    render 'game'
  end

  def ready_up
    @player = Player.find(params[:player_id])
    @player.deal_me_in
    render 'game'
  end

  def game_start
    @blackjack.prep_game
    @player = @blackjack.current_player_obj
    @hand = @player.current_hand_obj
    render 'game'
  end

  def redeal
    opts = {}
    opts[:rig_split] = 1 if params[:rig_split]
    opts[:rig_blackjack] = 1 if params[:rig_blackjack]
    @blackjack.reset # TODO - don't need to reset unless deck is out of cards (or close to it)
    @blackjack.prep_game(true, opts) # prep game and save game hands
    @player = @blackjack.current_player_obj || current_user.players.find_by(:game_id => @blackjack.id)
    @hand = @player.current_hand_obj
    render 'game'
  end

  private
    def set_blackjack
      @blackjack = Blackjack.find(params[:id])
    end

    def update_firebase
      push_blackjack_to_firebase(@blackjack)
    end
end
