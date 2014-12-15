class UsersController < ApplicationController
  
  def show
    set_created_polls
    set_polls 
  end

  def created_polls
    set_created_polls
    render json: { polls: @created_polls }
  end

  def polls
    set_polls
    render json: { polls: @polls }
  end 

  private

  def set_created_polls
    @created_polls = current_user.created_polls.paginate(page: params[:page], per_page: 3)
  end

  def set_polls
    @polls = current_user.polls.paginate(page: params[:polls_page], per_page: 3)
  end

end
