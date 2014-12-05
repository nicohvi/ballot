class PollsController < ApplicationController
  before_filter -> { set_poll(params[:id])     }, except: [:new, :create, :guest, :index]
  before_filter -> { authenticate(params[:id]) }, only:   [:edit, :destroy, :open, :close]
 
  def index

  end
 
  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params.merge(owner: current_user))
    @poll.save ? redirect_to(edit_poll_url(@poll)) : render('new')
  end

  def show
    respond_to do |format|
      format.html
      format.js { render json: @poll.to_json(user: current_user) }
    end
  end

  def edit
  end

  def destroy
    @poll.destroy!

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render json: { success: true }, status: 200 }
    end
  end

  def close
    @poll.close!
    redirect_to @poll
  end

  def open
    @poll.open!
    redirect_to @poll
  end

  def guest
    redirect_to Poll.find_by(guest_token: params[:guest_token])
  end

  private

  def poll_params
    params.require(:poll).permit(:name, :message)
  end

end
