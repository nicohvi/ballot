require 'will_paginate/array'
class UsersController < ApplicationController
  
  def show
    set_polls
    set_votes
  end

  private

  def set_polls
    @created_polls = current_user.created_polls.includes(:owner).paginate(page: params[:created_page], per_page: 5)
  end

  def set_votes
    @polls = @current_user.polls.includes(:owner).paginate(page: params[:polls_page], per_page: 5)
  end

end
