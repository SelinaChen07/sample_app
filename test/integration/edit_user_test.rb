require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = users(:chen)
    @another_user = users(:li)
  end

  test "edit with invalid information" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template "users/edit"
  	patch user_path(@user), params:{user:{name: "chen", email: "chen@hotmail.com", password: "123", password_confirmation: "12345"}}
  	assert_template "users/edit"
  end

  test "edit with valid information" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template "users/edit"
  	update_name = "S Chen"
  	update_email = "schen@gtmail.com"
  	patch user_path(@user), params:{user:{name: update_name, email: update_email, password: "123456", password_confirmation: "123456"}}
   	assert_not flash.empty?
  	follow_redirect!
  	@user.reload
  	assert_equal @user.name, update_name
  	assert_equal @user.email, update_email

  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

   test "should redirect update when not logged in" do
    patch user_path(@user), params:{user:{name:"", email:""}}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit to root when logged in as wrong user" do
   log_in_as(@user)
  #  post login_path params:{session:{email:"chen@gmail.com", password:"password"}}
    get edit_user_path(@another_user)
    assert_redirected_to root_path
  end

   test "should redirect update to root when logged in as wrong user" do
    log_in_as(@user)
    patch user_path(@another_user), params:{user:{name:"", email:""}}    
    assert_redirected_to root_path
  end

  test "friendly forward to edit page after successfully logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
  end

end
