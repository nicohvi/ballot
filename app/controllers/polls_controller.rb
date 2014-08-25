class PollsController < ApplicationController

  before_filter :authenticate, only: [:edit, :destroy]
  before_filter :login, only: [:create]

  def new
    @poll = Poll.new
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
    not_found unless @poll
    respond_to do |format|
      format.html
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message) }
    end
  end

  def edit
    @poll = Poll.find_by_slug(params[:id])
    render layout: false if request.xhr?
  end

  def destroy
    poll = Poll.find_by_slug(params[:id])
    poll.destroy!

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render json: { success: true }, status: 200 }
    end
  end

  def close
    @poll = Poll.find_by_slug(params[:id])
    @poll.close!

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message) }
    end
  end

  def open
    @poll = Poll.find_by_slug(params[:id])
    @poll.open!

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message) }
    end

  end

  def poll_params
    params.require(:poll).permit(:name, :message)
  end

end
