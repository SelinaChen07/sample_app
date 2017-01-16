require 'test_helper'
class SessionsHelperTest < ActionView::TestCase

	test "remember user" do
		user = users(:chen)
		remember(user)
		assert logged_in?
	end




end