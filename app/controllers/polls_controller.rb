class PollsController < ApplicationController
  before_filter :authenticate, only: [:edit, :destroy]
  before_filter :set_poll, except: [:new, :create] 
  
  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params.merge(owner: set_owner))
    @poll.save ? redirect_to(edit_poll_url(@poll)) : render('new')
  end

  def show
    not_found unless @poll
    respond_to do |format|
      format.html
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message) }
    end
  end

  def edit
  end

  def destroy
    poll.destroy!

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render json: { success: true }, status: 200 }
    end
  end

  def close
    @poll.close!

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message) }
    end
  end

  def open
    @poll.open!

    respond_to do |format|
      format.html { redirect_to @poll }
      format.js { render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message) }
    end

  end
  
  private

  def poll_params
    params.require(:poll).permit(:name, :message)
  end

  def set_poll
    @poll = Poll.find(params[:id])
  end
  
  def set_owner
    current_user.is_a?(Guest) ? nil : current_user
  end

end
