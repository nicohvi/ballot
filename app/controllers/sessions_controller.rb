class SessionsController < ApplicationController
  skip_before_action :current_user
  
  def create
    options = request.env['omniauth.auth']['info'].symbolize_keys!
    user = User.find_by_email(options[:email])
    user ||= User.create email: options[:email], name: options[:name]
    session[:user_id] = user.id
    redirect_to request.referrer
  end

  def destroy
    destroy_session
    redirect_to root_url
  end

  def user
    @poll = Poll.find_by_slug(params[:poll_id]) if params[:poll_id]

    respond_to do |format|
      format.js do |js|
        js.phone { render partial: 'sessions/header_phone' }
        js.none { render partial: 'sessions/header' }
      end
      format.html do |html|
        html.phone { render partial: 'sessions/header_phone' }
        html.none { render partial: 'sessions/header' }
      end
    end
  end

end
