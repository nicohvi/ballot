class VotesController < ApplicationController

  def index
    @votes = current_user.votes.includes(:poll, :option).paginate(page: params[:page], per_page: 5)
  end

end
