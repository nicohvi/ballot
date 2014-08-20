class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def authenticate
    redirect_to root_path unless @current_user == Poll.find_by_slug(params[:id]).owner
  end

end
