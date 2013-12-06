#-*- coding: utf-8 -*-#
class BlackjackController < ApplicationController
  before_action :require_signed_in
  before_action :set_blackjack, :only => [:join_game, :destroy_game]

  def find_game
    @games = Blackjack.all # .where(:privacy => 'public')
  end

  def new_game
  end

  def create_game
    redirect_to blackjack_join_path(Blackjack.create!(params[:blackjack_options]).id)
  end

  def join_game
    if can_join_game?(@blackjack)
      flash[:error] = "Thanks for trying to play a game, but it's not implemented yet."
      redirect_to root_path
    else
      flash[:error] = 'Sorry, that game is full.'
      redirect_to blackjack_find_path
    end
  end

  def destroy_game
    @blackjack.destroy
    redirect_to blackjack_find_path
  end

  private
    def set_blackjack
      @blackjack = Blackjack.find(params[:id])
    end
end
