class SessionsController < ApplicationController
  skip_before_action :current_user
  
  def create
    oauth_hash = request.env['omniauth.auth']['info'].symbolize_keys!
    user = User.find_by(email: oauth_hash[:email]) || User.create(user_params(oauth_hash))
    session[:user_id] = user.id
    redirect_to request.referrer || root_url
  end

  def destroy
    destroy_session
    redirect_to root_url
  end

  private

  def user_params(hash)
    hash.select { |key, value| %w(name email).include? key }
  end

end
