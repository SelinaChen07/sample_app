require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "Show invalid login message only on the login page" do
  	get login_path
  	assert_template "sessions/new"
  	post login_path, params:{session: {email: "invalidemail@email.com", password: "12345"}}
  	assert_template "sessions/new"
  	assert_not flash[:danger].empty?
  	get root_path
  	assert flash.empty?
  end

  test "Login with valid information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path params: {user: {name: "Chen", email: "chen@gmail.com", password: "123456", password_confirmation: "123456"}}
    end
    get login_path
    assert_template "sessions/new"
    post login_path params:{session:{email:"chen@gmail.com", password:"123456"}}
    assert_not flash[:success].empty?
    user = User.last
    assert_redirected_to user_path(user)
    follow_redirect!
    assert_select "a[href=?]", login_path, count:0
    assert_select "a[href=?]", logout_path
    assert_select "li", "Users"
  end

end
