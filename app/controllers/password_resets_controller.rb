class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :valid_user?, only:[:edit, :update]
  before_action :check_expiration, only:[:edit, :update]

  def new
  end

  #Consider when user input the wrong email address, or upcase email address, or the account is not activated yet.
  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user && @user.activated?
    	@user.create_reset_digest
    	@user.send_password_reset_email
    	flash[:success] = "Please check your email to reset password."
    	redirect_to root_path
    elsif @user && !@user.activated?
      flash[:danger]= "Account is not activated. Please activate the account first."
      redirect_to root_path
    else
      flash[:danger]= "Email not found."
      render "new"
    end
  end

  def edit
  	
  end


#Exceptions to consider on update:
#link expired
#password is nil. has_secure_password only forbid nil password on creation. We have allowed nil password in user update.
#password is invalid(eg:length less than 6) -- will be valideated by user.rb
#password and password confirmation not match -- will be valideated by user.rb
  def update
      if params[:user][:password].empty?
          @user.errors.add(:password, "can't be empty.")
          render "edit"
      elsif @user.update(user_params)
          flash[:success] = "Password has been reset successfully."
          log_in(@user)   #log in user automatically after password reset
          redirect_to user_path(@user)
      else
          render "edit"

      end      
  end

  private 
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
     @user = User.find_by(email: params[:email])
  end

  def valid_user?
    redirect_to root_path unless (@user && @user.activated? && @user.authenticate?(:reset, params[:id]))      
  end

  def check_expiration
    if @user.reset_link_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_path
    end
  end

end
