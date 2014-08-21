class UsersController < ApplicationController

  before_filter :login

  def polls
    @user = User.find(params[:id])
  end

end
