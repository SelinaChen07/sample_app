require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:chen)
  	@other_user = users(:user_1)
  end


  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should redirect index when not logged in" do
  	get users_url
  	assert_redirected_to login_path
  end

  test "should not allow admin attribute to be edited via the web" do
  	log_in_as(@other_user)
  	assert_not @other_user.admin?
  	patch user_path(@other_user), params:{user:{name: @other_user.name, email:@other_user.email, password:"", password_confirmation:"", admin: true}}
  	assert_not @other_user.admin?
  end

  test "should redirect delete to login if not logged in" do
  	assert_no_difference "User.count" do
  		delete user_path(@other_user)
  	end
  	assert_redirected_to login_path
  end

  test "should redirect delete to root if not admin" do
  	log_in_as(@other_user)
  	assert_no_difference "User.count" do
  		delete user_path(@other_user)
  	end
  	assert_redirected_to root_path
  end

  test "should redirect following if not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  
  test "should redirect followers if not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end

 

end
