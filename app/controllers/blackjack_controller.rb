#-*- coding: utf-8 -*-#
class BlackjackController < ApplicationController
  include FirebaseHelper

  before_action :require_signed_in
  before_action :set_blackjack, :only => [:join_game, :destroy_game,
                                          :ready_up, :game_start, :redeal,
                                          :hit, :stand, :double, :split]
  before_action :set_player, :only => [:hit, :stand, :double, :split]
  before_action :verify_action, :only => [:hit, :stand, :double, :split]

  after_action :update_firebase, :only => [:join_game, :ready_up, :game_start, :redeal,
                                           :hit, :stand, :double, :split]

  # Game search
  def find_game
    @games = Blackjack.all # .where(:privacy => 'public')
  end

  # Opening up a new room
  def new_game
  end

  # Creating a new room
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

  # Closing a room
  def destroy_game
    # TODO - do some permission checks here, might need to add attributes to model
    @blackjack.destroy
    redirect_to blackjack_find_path
  end

  # Allows a player to join a game.
  def join_game
    # check to see if the player is re-joining a game
    @player = current_user.players.where(:game_id => @blackjack.id).take
    if @player.nil? && can_join_game?(@blackjack)
      # if the game isn't full and the current user doesn't have a player in this
      # game, create the player
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
    @hand = @player.current_hand

    render 'game'
  end

  # Players need to click the 'Ready Up' button to indicate they are ready to play.
  # This method will update the player's :deal_in attribute, which is checked when
  # the Game model determines who to deal cards to.
  def ready_up
    @player = Player.find(params[:player_id])
    @player.deal_me_in

    render 'game'
  end

  def game_start
    @blackjack.reset_game
    # TODO - make the following two lines into after_actions
    @player = @blackjack.current_player
    @hand = @player.current_hand

    render 'game'
  end

  def redeal
    if @blackjack.num_players == 1
      opts = {}
      opts[:rig_split] = 1 if params[:rig_split]
      if params[:rig_blackjack]
        opts[:rig_blackjack] = 1
        opts.delete(:rig_split) # override rig_split if rig_blackjack
      end
    end

    @blackjack.reset_game(opts)

    # TODO - make the following two lines into after_actions
    @player = @blackjack.current_player ||
      # for cases where player(s) has blackjack
      current_user.players.find_by(:game_id => @blackjack.id)
    @hand = @player.current_hand

    render 'game'
  end

  def hit
    @action = 'hit'
    @blackjack.hit(@player)

    render 'game'
  end

  def stand
    @action = 'stand'
    @blackjack.stand(@player)

    render 'game'
  end

  def double
    @action = 'double'
    @blackjack.double(@player)

    render 'game'
  end

  def split
    @action = 'split'
    @blackjack.split(@player)

    render 'game'
  end

  private
    def set_blackjack
      @blackjack = Blackjack.find(params[:id])
    end

    def set_player
      @player = Player.find(params[:player_id])
    end

    def verify_action
      # TODO - somehow verify that this action is allowed
    end

    def update_firebase
      push_blackjack_to_firebase(@blackjack)
    end
end
