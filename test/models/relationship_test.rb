require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@chen = users(:chen)
  	@li = users(:li)
  end

  test "should follow and unfollow chen" do
  	assert_not @chen.following?(@li)
  	@chen.follow(@li)
  	assert @chen.following?(@li)
  	assert @li.followers.include?(@chen)
  	@chen.unfollow(@li)
  	assert_not @chen.following?(@li)
  end

  test "follower/followed should not be nil" do
  	assert_not @chen.active_relationships.create(followed_id: nil).valid?
  	assert_not @chen.follow(nil)
  end

end
