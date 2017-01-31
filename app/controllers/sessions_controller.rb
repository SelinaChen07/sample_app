class SessionsController < ApplicationController
  def new
    
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
  			flash[:success] = "Hi, #{@user.name} . Welcome to the Sample App!"
        log_in @user
        params[:session][:remember_me] == "1"? remember(@user) : @user.forget
        redirect_back_or(user_path(@user))
      else
        message = "Account not activated."
        message += "Please activate your account first."
        flash[:warning] = message
        redirect_to root_path
      end
  	else
  		flash.now[:danger] = "Invalid email or password!"
  		render "new"
  	end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
