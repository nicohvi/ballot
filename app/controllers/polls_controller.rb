class PollsController < ApplicationController

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)
    if @poll.save
      render @poll, layout: false, status: 200
    else
      render json: { errors: @poll.errors }, status: 401
    end
  end

  def poll_params
    params.require(:poll).permit(:name)
  end

end
