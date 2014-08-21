class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def destroy_session
    @current_user = session[:user_id] = nil
  end

  def authenticate
    redirect_to root_path unless Poll.find_by_slug(params[:id]) && current_user == Poll.find_by_slug(params[:id]).owner
  end

  def login
    unless current_user
      return render json: { errors: 'You need to be logged in to create a poll.'}, status: 401 if request.xhr?
      redirect_to root_path
    end
  end

end
