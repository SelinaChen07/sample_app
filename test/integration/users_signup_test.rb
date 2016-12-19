require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "do not save to db when form data is invalid" do
  	get signup_path
  	assert_no_difference "User.count" do
  		post users_path, params:{user:{name:"", email:"df@lk.com", password:"foo", password_confirmation:"fol"}}
  	end
  	assert_template "users/new"
  	assert_select "div.field_with_errors"
  	assert_select "div#error_explanation"
  end

  test "save to db when form data is valid" do
  	get signup_path
  	before_count = User.count
  	post users_path, params:{user:{name:"Li Li", email:"df@lk.com", password:"foo999", password_confirmation:"foo999"}}
  	after_count = User.count
  	assert_equal before_count+1, after_count
  	user=User.last
  	assert_redirected_to user_path(user)
  end


end
