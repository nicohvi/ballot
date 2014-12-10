class UsersController < ApplicationController

  def polls
    @created_polls = current_user.created_polls.paginate(page: params[:created_polls_page], per_page: 3)
    @polls = current_user.polls.paginate(page: params[:polls_page], per_page: 3)
  end

end
