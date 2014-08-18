class OptionsController < ApplicationController

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

  private

  def option_params
    params.require(:option).permit(:name)
  end

end
