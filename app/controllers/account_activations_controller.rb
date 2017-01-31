class AccountActivationsController < ApplicationController

def edit
	activation_token = params[:id]
	@user = User.find_by(email: params[:email])
	if @user && @user.authenticate?("activation", activation_token)
		@user.activate
		log_in @user
		flash[:success] = "Account activated."
		redirect_to user_path(@user)
	else
		flash[:danger] = "The activation link is invalid!"
		redirect_to root_path
	end

end

end
