class StaticPagesController < ApplicationController
  def home
  	if @user = current_user
  		@micropost = @user.microposts.new
      @feed_items = @user.feed.paginate(page:params[:page])
  	end
  end

  def help
  end

  def about
  end
  
  def contact
  end

end
