class OptionsController < ApplicationController
  before_filter -> { authenticate(params[:poll_id]) }, except: :vote
  before_filter -> { set_poll(params[:poll_id]) }
  layout false

  def new
    @option = @poll.options.build
    render '_form'
  end

  def create
    @option = @poll.options.create(option_params)
    @options.save ? render('option') : render('form')
  end

  def destroy
    @poll.options.find(params[:id]).destroy
    render nothing: true, status: 204
  end

  def vote
    option = @poll.options.find(params[:option_id])
    if current_user.vote(option)
      render json: @poll.to_json(:include => { :options => { :include => :votes } }, :methods => :message)
    else
      render json: { error: @poll.errors.messages[:base] }, status: 401
    end
  end

  private

  def option_params
    params.require(:option).permit(:name)
  end

end
