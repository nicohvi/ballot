class OptionsController < ApplicationController
  before_filter -> { set_poll(params[:poll_id]) }
  before_filter -> { authenticate(params[:poll_id]) }, except: :vote
  layout false

  def new
    @option = @poll.options.build
    render '_form'
  end

  def create
    @option = @poll.options.create(option_params)
    @option.save ? render(@option) : render(nothing: true, status: 400)
  end

  def update
    @option = @poll.options.find(params[:id])
    @option.update_attributes(option_params) ? render(nothing: true, status: 204) : render(nothing: true, status: 400)
  end

  def destroy
    @poll.options.find(params[:id]).destroy
    render nothing: true, status: 204
  end

  def vote
    option = @poll.options.find(params[:option_id])
    current_user.vote(option) ? render(json: { vote: option.id, options: @poll.options }) : error
    #current_user.vote(option) ? render(json: { poll: @poll.to_json, option: option.id } ) : error
  end

  private

  def option_params
    params.require(:option).permit(:name)
  end

end
