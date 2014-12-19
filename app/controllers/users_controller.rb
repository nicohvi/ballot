require 'will_paginate/array'
class UsersController < ApplicationController
  
  def show
    set_polls
    set_votes
  end

  def created_polls
    set_polls
    render json: { polls: @created_polls, created: true }
  end

  def voted_polls
    set_votes
    render json: { polls: JSON.parse(@polls.to_json(user: current_user)), created: false }
  end

  private

  def set_polls
    @created_polls = current_user.created_polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

  def set_votes
    @polls = @current_user.polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

end
