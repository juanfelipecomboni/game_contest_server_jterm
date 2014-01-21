class UsersController < ApplicationController
  before_action :ensure_user_logged_out, only: [:new, :create]
  before_action :ensure_user_logged_in, only: [:edit, :update, :destroy]
#  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_correct_user_or_admin, only: [:edit, :update]
  before_action :ensure_admin, only: [:destroy]


  def new
    @user = User.new
  end

  def create
    @user = User.new(acceptable_params)
    if @user.save
      flash[:success] = "Welcome to the site: #{@user.username}"
      login @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    if @users.length == 0
      flash.now[:info] = "There were no users that matched your search. Please try again!"
    end
  end


  def show
    @user = User.friendly.find(params[:id])
  end

  def edit
  end

  def update
    if current_user.admin and @user.update(admin_params)
      flash[:success] = "Privilages for #{@user.username} have been changed."
      redirect_to root_path
    elsif @user.update(acceptable_params)
      flash[:success] = "Your profile has been modified"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.username} removed from the site"
    redirect_to users_path
  end

  def admin
    if @user.update(admin_params)
      flash[:success] = "Privilages for #{@user.username} have been changed."
    end
  end

private

  def acceptable_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end

    def admin_params
      params.require(:user).permit(:banned, :admin, :contest_creator)
    end

    def ensure_user_logged_out
      unless !logged_in?
	flash[:warning] = 'You are already logged in.'
	redirect_to root_path
      end
    end

  def ensure_admin
    @user = User.friendly.find(params[:id])
    request_okay = true
    unless !current_user?(@user)
      flash[:danger] = 'Users may not delete themselves.'
      request_okay = false
    end
    unless current_user.admin?
      flash[:danger] = 'Only administrators can delete users.'
      request_okay = false
    end
    redirect_to root_path unless request_okay
  end

  def ensure_correct_user_or_admin(user_id = params[:id])
    @user = User.find(user_id)
    unless current_user?(@user) or current_user.admin
      flash[:danger] = 'Unable to edit another user\'s stuff.'
      redirect_to root_path
    end
  end
end
