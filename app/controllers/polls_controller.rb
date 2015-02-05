class PollsController < ApplicationController
  before_filter -> { set_poll(params[:id])     }, except: [:new, :create, :guest, :index]
  before_filter -> { authenticate(params[:id]) }, only:   [:edit, :destroy, :open, :close]

  def index
    @polls = current_user.created_polls.includes(:votes).paginate(page: params[:page], per_page: 5)
  end
 
  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params.merge(owner: current_user))
    if @poll.save
      redirect_to(edit_poll_url @poll)
    else
      flash[:error] = t('poll.errors.guest_token', link: new_user_path) unless @poll.errors[:guest_token].empty?
      render 'new'
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js { render json: @poll.to_json(user: current_user, include: :options) }
    end
  end

  def edit
  end

  def update
    if @poll.update(poll_params)
      flash[:notice] = 'Poll updated.'
      redirect_to(@poll)
    else
      render 'edit'
    end
  end

  def destroy
    @poll.destroy!
    flash[:notice] = t('poll.actions.destroy')
    guest? ? redirect_to(root_path) : redirect_to(@current_user)  
  end

  def close
    @poll.close!
    flash[:notice] = t('poll.actions.close')
    path = request.referrer || @poll
    redirect_to path
  end

  def open
    @poll.open!
    flash[:notice] = t('poll.actions.open')
    path = request.referrer || @poll
    redirect_to path
  end

  def guest
    redirect_to Poll.find_by(guest_token: params[:guest_token])
  end

  private

  def poll_params
    params.require(:poll).permit(:name, :allow_anonymous, :secret)
  end

end
