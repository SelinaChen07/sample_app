require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:chen)
  	@other_user = users(:li)
  end

  test "should redirect follow when not logged in" do
  	assert_no_difference 'Relationship.count' do
  		post relationships_path(followed_id: @other_user.id)
  	end
  	assert_redirected_to login_path
  end

  test "should redirect unfollow when not logged in" do
  	assert_no_difference 'Relationship.count' do
  		delete relationship_path(relationships(:one))
  	end
  	assert_redirected_to login_path
  end


end
