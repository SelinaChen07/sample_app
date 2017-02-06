require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	ActionMailer::Base.deliveries.clear
  	@user = users(:li)
  end

  test "password reset" do
  	get login_path
  	assert_select "a[href=?]", new_password_reset_path, text: "(Forget Password?)"
  	get new_password_reset_path
  	assert_template "password_resets/new"
  	#invalid email address
  	post password_resets_path, params:{password_reset:{email: "invalid@example.com"}}
  	assert_not flash.empty?
  	assert_template "password_resets/new"
  	#valid email address
  	post password_resets_path, params:{password_reset:{email: @user.email}}
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	assert_not flash.empty?
  	assert_redirected_to root_path

  	user = assigns(:user)
  	#invalid password reset token
  	get edit_password_reset_path("wrongtoken", email: @user.email)
  	assert_redirected_to root_path
  	#invalid password reset email
  	get edit_password_reset_path("wrongtoken", email: "invalid@example.com")
  	assert_redirected_to root_path
  	#valid password reset link
  	get edit_password_reset_path(user.reset_token, email: @user.email)
  	assert_template "password_resets/edit"
  	#invalid password update
  	patch password_reset_path(user.reset_token, email:@user.email), params:{user:{password:"", password_confirmation:""}}
  #	assert_equal 1, @user.errors.size 
    assert_select 'div#error_explanation'
  	assert_template "password_resets/edit"
  	#invalid password update
  	patch password_reset_path(user.reset_token, email:@user.email), params:{user:{password:"foo", password_confirmation:"123"}}
  #	assert_equal 2, user.errors.size 
  	assert_select 'div#error_explanation'
  	assert_template "password_resets/edit"
  	#valid password update
  	patch password_reset_path(user.reset_token, email:@user.email), params:{user:{password:"1234567", password_confirmation:"1234567"}}
  	assert_not flash.empty?
  	assert_redirected_to user_path(@user)
  	follow_redirect!
  	assert_select "a[href=?]", login_path, count:0
  	assert_select "a[href=?]", logout_path, count:1
  	#password link expired
  	@user.update_attribute(:reset_send_at, 3.hours.ago)
  	patch password_reset_path(user.reset_token, email:@user.email), params:{user:{password:"123456", password_confirmation:"123456"}}
  	assert_not flash.empty?
  	assert_redirected_to new_password_reset_path
  	

  end

end
