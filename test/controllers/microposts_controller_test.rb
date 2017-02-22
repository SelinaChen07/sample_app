require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
 
 def setup
 	@user = users(:chen)
 	@micropost_other_user = microposts(:apple)
 	@micropost_correct_user = microposts(:one)
 end

 test "should be redirected when create micropost without logging in" do 
 	assert_no_difference "@user.microposts.count" do
		post microposts_path, {params:{micropost:{content:"I am new."}}}
	end
 	assert_not flash.empty?
 	assert_redirected_to login_path 	
 end

test "should create when logged in" do
	log_in_as(@user)
	assert_difference "@user.microposts.count", 1 do
		post microposts_path, {params:{micropost:{content:"I am new."}}}
	end
	assert_redirected_to root_path
end

test "should redirect destroy when not logged in" do
	assert_no_difference "Micropost.count" do
		delete micropost_path(@micropost_correct_user)
	end
	assert_not flash.empty?
 	assert_redirected_to login_path 
 end

 test "should redirect destroy when not logged in as correct user" do
 	log_in_as(@user)
 	assert_no_difference "Micropost.count" do
		delete micropost_path(@micropost_other_user)
	end
 	assert_redirected_to root_path
 end

 test "should destroy when logged in as correct user" do
 	log_in_as(@user)
 	assert_difference "@user.microposts.count", -1 do
		delete micropost_path(@micropost_correct_user)
	end
	assert_redirected_to root_path
 end

end
