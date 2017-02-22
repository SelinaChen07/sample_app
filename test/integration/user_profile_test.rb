require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = users(:chen)
  end

  test "user profile display" do
  	get user_path(@user)
  	assert_template "users/show"
  	assert_select 'title', full_title(@user.name)
  	assert_select 'h1', @user.name
  	assert_select 'h1>img.gravatar'
  	assert_select 'div.pagination'
  	assert_match @user.microposts.count.to_s, response.body
  	@user.microposts.paginate(page:1).each do |micropost|
  		assert_match micropost.content,response.body
  	end

  end

end
