class PollsController < ApplicationController

  def new
    @poll = Poll.new
    render 'new', layout: false if request.xhr?
  end

  def create
    @poll = Poll.new(poll_params)
    if @poll.save
      render 'edit', layout: false, status: 200
    else
      render json: { errors: @poll.errors }, status: 401
    end
  end

  def show
    @poll = Poll.find_by_slug(params[:id])
    pr @poll
    respond_to do |format|
      format.html
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }) }
    end
  end

  def edit
    @poll = Poll.find_by_slug(params[:id])
  end

  def poll_params
    params.require(:poll).permit(:name)
  end

end
