class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    session[:user_id] = user.id
    redirect_to(user_path(user))
  end

  def destroy
    session[:user_id] = nil
    redirect_to(login_path)
  end
end
