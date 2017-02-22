require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
def setup
	@user = users(:chen)
	@most_recent_post = microposts(:most_recent)
end

test "should return invalid when content is empty" do
	assert_not @user.microposts.create(content: "").valid?
end

test "should return invalid when content is longer than 140 charaters" do
	post = "a"*141
	assert_not @user.microposts.create(content: post).valid?
end

test "should return invalid when user_id is empty" do
	micropost = Micropost.new(content: "This is a test without user id.")
	assert_not micropost.save
end

test "microposts should be destroy when user is deleted" do
	user = User.create(name: "Temp_user", email: "temp_user@example.com", password: "123456", password_confirmation: "123456")
	user.microposts.create(content: "Micropost1 for temp_user")
	user.microposts.create(content: "Micropost2 for temp_user")
	assert_difference 'Micropost.count', -2 do
		user.destroy
	end
end

test "most recent post should come first" do
	assert_equal Micropost.first, @most_recent_post
end

end