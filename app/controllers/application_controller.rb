class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # these methods allow us to access the user currently in
  #   the session for any given browser request, and offers
  #   semantic helpers we can use in any of our controllers
  #   to authenticate (handle) a given request based on the
  #   session state
  #
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def authenticate
    redirect_to login_path unless logged_in?
  end

  def log_out!
    session[:user_id] = nil
  end

  # if you want to use these methods in our views as well
  #   as the inheriting controllers, you need to declare
  #   them as "helper methods" using the macro (meta-programming
  #   method, like `attr_reader`, etc.) below
  #
  # helper_method :current_user, :logged_in?, :authenticate, :is_admin?
end
