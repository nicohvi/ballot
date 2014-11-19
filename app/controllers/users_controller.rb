class UsersController < ApplicationController

  def polls
    @user = User.find(params[:id])
  end

end
