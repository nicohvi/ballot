class SessionsController < ApplicationController

  def create
    options = request.env['omniauth.auth']['info'].symbolize_keys!
    user = User.find_by_email(options[:email])
    user ||= User.create email: options[:email], name: options[:name]
    session[:user_id] = user.id
    render 'sessions/new', layout: false
  end

  def destroy
    destroy_session
    render nothing: true
  end

  def user
    render 'sessions/user', layout: false
  end

end
