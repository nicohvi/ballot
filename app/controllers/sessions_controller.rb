class SessionsController < ApplicationController

  def create
    options = request.env['omniauth.auth']['info'].symbolize_keys!
    user = User.find_by_email(options[:email])
    user ||= User.create email: options[:email], name: options[:name]
    session[:user_id] = user.id
    render partial: 'sessions/new', layout: false
  end

  def destroy
    destroy_session
    render nothing: true
  end

  def user
    @poll = Poll.find_by_slug(params[:poll_id]) if params[:poll_id]
    render partial: 'sessions/header', layout: false
  end

end
