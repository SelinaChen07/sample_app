require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "do not save to db when form data is invalid" do
  	get signup_path
  	assert_no_difference "User.count" do
  		post users_path, params:{user:{name:"", email:"df@lk.com", password:"foo", password_confirmation:"fol"}}
  	end
  	assert_template "users/new"
  	assert_select "div.field_with_errors"
  	assert_select "div#error_explanation"
  end

  test "valid sign up with account activation" do
  	get signup_path
  	before_count = User.count
  	post users_path, params:{user:{name:"Li Li", email:"df@lk.com", password:"foo999", password_confirmation:"foo999"}}
  	after_count = User.count
  	assert_equal before_count+1, after_count
  	user=assigns(:user)
#  	assert_redirected_to user_path(user)
#    follow_redirect!
#    assert_select "a[href=?]", login_path, count:0
#    assert_select "a[href=?]", logout_path
#    assert_select "li", "Users"

    # redirect to home page after sign in
    assert_not user.activation_digest.nil?
    assert_not user.activated?
    assert_not user.activation_token.nil?
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash.empty?
    assert_select "a[href=?]", login_path, count:1
    assert_select "a[href=?]", logout_path, count:0

    # try to log in without account activation
    get login_path
    log_in_as(user)
    assert_not flash.empty?
    

    # log in with account activation
    get edit_account_activation_url(user.activation_token, email:user.email)
    assert_not flash.empty?
    user.reload
    assert user.activated?
    assert_redirected_to user_path(user)
    follow_redirect!
    assert_select "a[href=?]", login_path, count:0
    assert_select "a[href=?]", logout_path
    assert_select "li", "Users"

  end

end
