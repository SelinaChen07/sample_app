require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@admin_user = users(:chen)
    @non_admin = users(:li)
  end

  test "index including pagination and delete link when logged in as admin" do
  	log_in_as(@admin_user)
  	get users_path
  	assert_template "users/index"
  	assert_select "div.pagination",count:2
  	users = User.paginate(page: 1)
  	users.each do |user|
  		assert_select "a[href=?]", user_path(user), text:user.name
      assert_select "a[href=?]", user_path(user), text:"Delete" unless user == @admin_user
  	end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
    assert_not flash.empty?
    follow_redirect!
    assert_template "users/index"
  end

  test "no delete links when logged in as non_admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select  'a', text:"Delete", count:0
  end

end
