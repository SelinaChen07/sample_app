class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

 
  def show
  	@user = User.find(params[:id])
    redirect_to root_path unless @user.activated
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate the account."
      redirect_to root_path
 #     log_in(@user)
 # 		flash[:success] = "Welcome to the Sample App!"
 # 		redirect_to user_path(@user)
  	else
  		render "new"
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:sucess] = "You've successfully updated your profile."
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

  def index
      @users = User.where(activated:true).paginate(page:params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  private
  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    if !logged_in?
      store_location
      flash[:danger] = "Please log in first."
      redirect_to login_path
    end
  end

  def correct_user
    if !current_user?(User.find_by(id: params[:id]))
      redirect_to root_path
    end
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

end
