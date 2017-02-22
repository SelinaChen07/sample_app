require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:chen)
  	@other_user = users(:li)
  	@micropost = microposts(:one)
  end

  test "micropost interface test" do
  	log_in_as @user
  	get root_path
  	assert_select "section.micropost_form"
  	assert_select "input[type=file]"
  	#invalid submission
  	assert_no_difference "@user.microposts.count" do
		post microposts_path, {params:{micropost:{content:""}}}
	end
	assert_select "div#error_explanation"
	#valid submission
	picture_upload = fixture_file_upload("public/uploads/RackMultipart20170222-18385-1si0xi1.png", "image/png")
	assert_difference "@user.microposts.count", 1 do
		post microposts_path, {params:{micropost:{content:"I am new.", picture: picture_upload}}}
	end
	assert @user.microposts.first.picture?
	assert_redirected_to root_path
	follow_redirect!
	assert_match "I am new", response.body
	assert_select "img[src=?]", @user.microposts.first.picture.url
	#delete post
	assert_difference "@user.microposts.count", -1 do
		delete micropost_path(@micropost)
	end
	#visit differenct user, no delete link
	get user_path(@other_user)
	assert_select 'a', text:"Delete", count: 0
  end

end
