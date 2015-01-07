require 'will_paginate/array'
class UsersController < ApplicationController
 
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

  def set_polls
    @created_polls = current_user.created_polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

  def set_votes
    @polls = @current_user.polls.includes(:owner).paginate(page: params[:page], per_page: 5)
  end

end
