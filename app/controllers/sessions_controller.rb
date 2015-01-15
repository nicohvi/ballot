class SessionsController < ApplicationController
  skip_before_action :current_user
  
  def create
    oauth_hash = request.env['omniauth.auth']['info'].symbolize_keys!
    user = User.find_by(email: oauth_hash[:email]) || User.create(user_params(oauth_hash))
    sign_in(user) 
    redirect_to user
  end

  def destroy
    logout
    redirect_to root_url
  end

  private

  def user_params(hash)
    hash.select { |key, value| %w(name email).include? key }
    hash.merge({ password_digest: SecureRandom.urlsafe_base64 })
  end

end
