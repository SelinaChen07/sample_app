require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:chen)
    @other_user = users(:li)
    @relationship = relationships(:one)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match "Following", response.body
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow as the standard way" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, params:{followed_id: @other_user.id}
    end
  end

  test "should follow a user with Ajax" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, params:{followed_id: @other_user.id}, xhr:true
    end
  end

  test "should unfollow as the standard way" do
    assert_difference "@user.following.count", -1 do
      delete relationship_path(@relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    assert_difference "@user.following.count", -1 do
      delete relationship_path(@relationship), xhr:true
    end
  end

end
