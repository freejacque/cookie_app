class UsersController < ApplicationController
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, :authorize

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
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
    redirect_to(users_path)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end

    def load_user
      @user = User.find(params[:id])
      redirect_to root_path if !@user
    end

    def authenticate
      redirect_to login_path if !logged_in?
    end

    def authorize
      if current_user != @user && current_user.role != "patissier"
      redirect_to user_path(current_user)
      end
    end
end
