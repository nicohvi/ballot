class OptionsController < ApplicationController

  before_filter :login

  def new
    @poll = Poll.find_by_slug(params[:poll_id])
    @option = @poll.options.build
    render partial: 'form', layout: false
  end

  def create
    @poll = Poll.find_by_slug(params[:poll_id])
    @option = @poll.options.create(option_params)

    if @option.save
      render @option, layout: false
    else
      render json: { errors: @option.errors }, status: 401
    end
  end

  def destroy
    poll = Poll.find_by_slug(params[:poll_id])
    poll.options.find(params[:id]).destroy
    render json: { success: true }
  end

  def vote
    @poll = Poll.find_by_slug(params[:poll_id])
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
