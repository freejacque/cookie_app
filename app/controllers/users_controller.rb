class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    #make sure the user is authenticated
    #make sure the authenticated user is this user
    # who is the user being accessed?
    if !load_user
      redirect_to root_path
    # who is trying to access this? are they a user?
    # if they are a user, who is the user who is trying to access?
    elsif !logged_in?
      redirect_to login_path
    # is the user trying to access this the same as the user being accessed?
    elsif
      current_user != @user && current_user.role != "patissiere"
      redirect_to user_path(current_user)
    else
      render(:show)
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render(:edit)
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to(user_path)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end

    def load_user
      @user = User.find(params[:id])
    end
end
