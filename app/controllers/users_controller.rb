require 'will_paginate/array'
class UsersController < ApplicationController
  before_action :require_login, except: [:new, :login]

  def new
    @user = User.new
  end

  def login
    @user = User.find_by(email: user_params[:email]) 
    if @user && @user.authenticate(user_params[:password])
      sign_in(@user) 
      redirect_to @user
    else
      error
    end
  end
 
  def show
    set_polls
    set_votes
  end

  def created_polls
    render partial: 'polls', locals: { polls: set_polls, tools: true}, layout: false
  end

  def voted_polls
    set_votes
    render partial: 'polls', locals: { polls: set_votes, show_vote: true }, layout: false
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_polls
    @created_polls = current_user.created_polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

  def set_votes
    @polls = @current_user.polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

end
