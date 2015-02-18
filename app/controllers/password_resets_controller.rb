class PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    user.send_password_reset if user
    redirect_to root_url, notice: t('user.password_reset.sent')
  end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])
    if user_params[:password].empty?
      flash[:error] = t('user.errors.empty_password')
      return render 'edit'
    end
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, flashh[:alert] = t('user.password_reset.expired')
    elsif @user.update_attributes(user_params)
      sign_in(@user) 
      redirect_to root_url, notice: t('user.password_reset.sent')
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
