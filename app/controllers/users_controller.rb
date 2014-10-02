class UsersController < ApplicationController

  before_action :authenticate,          except: [:new, :create]
  before_action :load_user,             only:   [:show, :edit, :update, :destroy]
  before_action :authorize_admin_only,  only:   :index
  before_action :authorize_user_access, only:   [:show, :edit, :update, :destroy]

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
  end

  # POST /users
  def create
    @user = User.new({role: 'customer'}.merge(user_params))

    if @user.save
      log_in(@user)
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

  def user_params
    params.require(:user).permit(
      :email,
      :name,
      :favorite_recipe_id,
      :password,
      :password_confirmation
    )
  end

  def load_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path if !@user
  end

  def authorize_admin_only
    unless current_user.is_admin?
      redirect_to user_path(current_user)
    end
  end

  def authorize_user_access
    unless current_user == @user || current_user.is_admin?
      redirect_to user_path(current_user)
    end
  end
end
