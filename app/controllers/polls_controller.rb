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

  def update
    @poll.update_attributes(poll_params) ? render(nothing: true, status: 204) : render( json: { errors: @poll.errors }, status: 400)
  end

  def destroy
    @poll.destroy!

    path = request.referrer || root_path
    redirect_to path
  end

  def close
    @poll.close!
    redirect_to edit_poll_url(@poll)
  end

  def open
    @poll.open!
    redirect_to edit_poll_url(@poll)
  end

  def guest
    redirect_to Poll.find_by(guest_token: params[:guest_token])
  end

  private

  def poll_params
    params.require(:poll).permit(:name, :allow_anonymous)
  end

end
