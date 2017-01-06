class SessionsController < ApplicationController
  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
  			flash[:success] = "Hi, #{@user.name} . Welcome to the Sample App!"
        log_in @user
  			redirect_to user_path(@user)
  	else
  		flash.now[:danger] = "Invalid email or password!"
  		render "new"
  	end
  end

  def destroy
    log_out
    redirect_to root_path
  end

end
