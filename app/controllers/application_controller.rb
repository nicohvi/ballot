class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :detect_device_format
  layout :set_layout

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def destroy_session
    @current_user = session[:user_id] = nil
  end

  def authenticate(poll_id)
    redirect_to root_path unless Poll.find(poll_id).owner == current_user 
  end
  
  def set_poll(poll_id)
    @poll = Poll.find(poll_id)
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

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
