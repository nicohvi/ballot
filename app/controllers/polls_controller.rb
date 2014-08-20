class PollsController < ApplicationController

  before_filter :authenticate, only: [:edit]
  before_filter :login, only: [:create]

  def new
    @poll = Poll.new
    render 'new', layout: false if request.xhr?
  end

  def create
    @poll = Poll.new(poll_params)
    @poll.owner = current_user
    if @poll.save
      render 'edit', layout: false, status: 200
    else
      render json: { errors: @poll.errors }, status: 401
    end
  end

  def show
    @poll = Poll.find_by_slug(params[:id])
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message) }
    end
  end

  def edit
    @poll = Poll.find_by_slug(params[:id])
  end

  def poll_params
    params.require(:poll).permit(:name, :message)
  end

end
