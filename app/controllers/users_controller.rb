class UsersController < ApplicationController

  # 1. the first thing we do is ensure that the browser that made
  #   the request is authenticated as someone in our database
  # 2. we do this by checking an authenticate method defined for
  #   every controller in ApplicationController
  # 3. because we are putting all user actions except sign up
  #   and new user creation (you can't be authenticated if
  #   you're not) on the site yet, we'll authenticate all except
  #   those...
  #
  before_action :authenticate, except: [:new, :create]

  # 1. the next thing we do is load the current resource, which in
  #   this case is user -- thus, "load_user"...
  # 2. the load_user method is in this class because it references
  #   the current resource -- it won't be a universal need for
  #   authentication and authorization!
  # 3. we need to load the user on the "member routes", ie
  #   routes with an "/:id", which are (from rake routes)
  #   edit, show, update and destroy...
  #
  before_action :load_user, only: [:show, :edit, :update, :destroy]

  # 1. finally, we ensure that the authenticated user has the right
  #   to access the loaded resource
  # 2. this is VERY dependent on the logic of our routes and
  #   resources, and so is defined within this controller!
  # 3. anyone has the right to access the new and create routes,
  #   and only admins (in cookie CRUD world, patissieres) can
  #   access the index page (all users), otherwise (edit, show,
  #   update and destroy) if the authenticated user IS the same as
  #   the loaded resource user they can see the page AND admins
  #   can see the page too...
  #
  before_action :authorize_admin_only, only: :index
  before_action :authorize_user_access, only: [:show, :edit, :update, :destroy]

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
    # see the user_params method below...
    # also: adding a default customer role on creation, removed that from params
    #   since it would have forced everyone to be a customer when they updated!
    @user = User.new({role: 'customer'}.merge(user_params))

    if @user.save
      log_in(@user) # we log in with our new method in ApplicationController!
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
    # this is an example of Rails 4's "strong params" pattern...
    # you can read more about it here:
    #   http://edgeguides.rubyonrails.org/action_controller_overview.html#strong-parameters
    # it's too hard to go in to in this comment, but essentially we are going
    #   to state explicitly below which of the form_for tags we will allow to be
    #   assigned on creation for security purposes. explore the params hash
    #   for more detail -- or ask me! (pj)
    def user_params
      params.require(:user).permit(
        :email,
        :name,
        :favorite_recipe_id,
        :password,
        :password_confirmation
      )
    end

    # puts the correct user into the @user instance variable whenever called, and
    #  also handles the situation where we have referenced a user resource that
    #  is not in the database!
    def load_user
      @user = User.find_by(id: params[:id]) # needs to be find_by to avoid the error!
      redirect_to root_path if !@user # probably should add a message to this...
    end

    def authorize_admin_only
      unless current_user.is_admin? # this is defined on the model!
        redirect_to user_path(current_user)
      end
    end

    def authorize_user_access
      # reversed the login on this a little bit, unless meaning NOT :)
      #   i think it reads easier, tho
      unless current_user == @user || current_user.is_admin?
        redirect_to user_path(current_user)
      end
    end
end
