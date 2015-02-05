class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  protect_from_forgery with: :exception
  before_action :current_user
  layout :set_layout

  private

  def require_login
    redirect_to new_poll_path if guest?
  end

  def guest?
    @current_user.is_a?(Guest)
  end

  def logout
    @current_user = session[:user_id] = nil
    flash[:notice] = t('user.logout')
  end

  def sign_in(user)
    session[:user_id] = user.id
    flash[:notice] = t('user.login')
  end

  def authenticate(poll_id)
    redirect_to root_path unless @poll.owned_by?(current_user)
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def error
    render text: t('error'), status: 401
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
    @current_user ||= create_guest
  end

  def create_guest
    if cookies[:guest_token].nil?
      cookies[:guest_token] = {
        value:    SecureRandom.uuid,
        expires:  20.years.from_now.utc
      }
    end
    Guest.new(cookies[:guest_token])
  end

  def set_poll(poll_id)
    @poll = Poll.find(poll_id)
    not_found unless @poll
  end

  def set_layout
    false if request.xhr?
  end

end
