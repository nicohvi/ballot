class OptionsController < ApplicationController

  def new
    @poll = Poll.find(params[:poll_id])
    @option = @poll.options.build
    render partial: 'form', layout: false
  end

  def create
    poll = Poll.find(params[:poll_id])
    @option = poll.options.create(option_params)

    if @option.save
      render @option, layout: false
    else
      render json: { errors: @option.errors }, status: 401
    end
  end

  private

  def option_params
    params.require(:option).permit(:name)
  end

end
