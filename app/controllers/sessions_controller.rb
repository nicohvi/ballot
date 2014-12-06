class SessionsController < ApplicationController
  skip_before_action :current_user
  
  def create
    oauth_hash = request.env['omniauth.auth']['info'].symbolize_keys!
    user = User.where(user_params(oauth_hash)).first_or_create
    session[:user_id] = user.id
    redirect_to request.referrer || root_url
  end

  def destroy
    destroy_session
    redirect_to root_url
  end

  private

  def user_params(hash)
    hash.permit(:email, :name, :image)
  end

end
