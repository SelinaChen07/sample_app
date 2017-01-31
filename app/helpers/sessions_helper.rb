module SessionsHelper
	def log_in (user)
		session[:user_id] = user.id
	end

	def current_user
		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		elsif cookies.signed[:user_id]
			user= User.find_by(id: cookies.signed[:user_id])
			if user && user.authenticate?("remember", cookies[:remember_token])
				@current_user ||= user
				log_in(user)
			else
				@current_user = nil
			end
		else
			@current_user = nil			
		end
	end

	def logged_in?
		!!current_user
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def current_user?(user)
		(user !=nil && user == current_user)? true : false
		
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end

	def redirect_back_or(default_url)
		redirect_to(!session[:forwarding_url].nil?? session[:forwarding_url] : default_url)
		session.delete(:forwarding_url)
	end	

end
