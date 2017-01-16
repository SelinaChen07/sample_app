require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "Show invalid login message only on the login page" do
  	get login_path
  	assert_template "sessions/new"
    assert session[:user_id].nil?
  	post login_path, params:{session: {email: "invalidemail@email.com", password: "12345"}}
  	assert_template "sessions/new"
  	assert_not flash[:danger].empty?
  	get root_path
  	assert flash.empty?
  end

  test "Login with valid information followed by a logout" do
#    get signup_path
#    assert_difference "User.count", 1 do
#      post users_path params: {user: {name: "Chen", email: "chen@gmail.com", password: "password", password_confirmation: "password"}}
#    end
    get login_path
    assert_template "sessions/new"
    post login_path params:{session:{email:"chen@gmail.com", password:"password"}}
    assert_not flash[:success].empty?
    assert_not session[:user_id].nil?
  #  assert_not cookies[:user_id].nil?
  #  assert_not cookies[:remember_token].nil?
    user = users(:chen)
    assert_redirected_to user_path(user)
    follow_redirect!
    assert_select "a[href=?]", login_path, count:0
    assert_select "a[href=?]", logout_path
    assert_select "li", "Users"
    #logout
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert session[:user_id].nil?
  #  assert cookies.signed[:user_id].nil?
  #  assert cookies[:remember_token].nil?
  end

    test "Valid login with remembering me" do
      post login_path params:{session:{email:"chen@gmail.com", password: "password", remember_me: "1"}}
      assert_not_empty cookies['remember_token'] 

    end

    test "Valid login with not remembering me" do
      post login_path params:{session:{email:"chen@gmail.com", password: "password", remember_me: "0"}}
      assert cookies['remember_token'].nil?
    end

end
