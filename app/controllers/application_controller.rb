class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :detect_device_format, :current_user
  layout :set_layout

  private

  def guest?
    @current_user.is_a?(Guest)
  end

  def destroy_session
    @current_user = session[:user_id] = nil
  end

  def authenticate(poll_id)
    redirect_to root_path unless @poll.owned_by?(current_user)
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def error
    render text: 'You did something wrong, fool', status: 401
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
    @poll = Poll.includes(:owner).find(Poll.decode_id(poll_id))
    not_found unless @poll
  end

  def detect_device_format
    case request.user_agent
    when /iPad/i
      request.variant = :tablet
    when /iPhone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    when /Android/i
      request.variant = :tablet
    when /Windows Phone/i
      request.variant = :phone
    end
  end

  def set_layout
    case request.variant
    when [:phone]
      return 'phone'
    when [:tablet]
      return 'tablet'
    end
    false if request.xhr?
  end

end
