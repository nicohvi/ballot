require 'will_paginate/array'
class UsersController < ApplicationController
  before_action :require_login, only: [:show, :created_polls, :voted_polls]
  before_action :new_user, only: [:new, :login_form, :register_form] 

  def new
  end

  def login
    @user = User.find_by(email: user_params[:email]) 
    if @user && @user.authenticate(user_params[:password])
      sign_in_and_redirect
    else
      if @user.nil?
        flash[:error] = t('user.errors.wrong_email')
      else
        @user = User.new(user_params)
        flash[:error] = t('user.errors.wrong_password')
      end
      render 'new'
    end
  end

  def login_form
    render partial: 'login_form'
  end

  def register_form
    render partial: 'register_form' 
  end  

  def create
    @user = User.new(user_params)
    @user.save ? sign_in_and_redirect : render('new')
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
  
  def new_user
    @user = User.new
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def sign_in_and_redirect
    sign_in(@user)
    redirect_to(@user)
  end

  def set_polls
    @created_polls = current_user.created_polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

  def set_votes
    @polls = @current_user.polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

end
