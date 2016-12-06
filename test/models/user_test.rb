require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = User.new(name: "Mike Mann", email: "mikemann@lenovo.com", password: "123456", password_confirmation: "123456")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = ''
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = ''
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = 'a'*51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = 'a'*245+"@lenovo.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid email address" do
  	valid_addresses = %w[abc.drd@gmail.com ITL-kjl@jka.com alice+bob@erf.ark.org]
  	valid_addresses.each do |a|
  		@user.email = a
  		assert @user.valid?, "#{a.inspect}should be valid."
  	end
  end


  test "email validation should reject invalid email address" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
  	invalid_addresses.each do |a|
  		@user.email = a
  		assert_not @user.valid?, "#{a.inspect}should be invalid."
  	end
  end

  test "email address should be unique" do
   		 user_duplicate = @user.dup
   		 user_duplicate.email = @user.email.upcase
   		 @user.save  # Running the test won't change the database
  		assert_not user_duplicate.valid?
  end

  test "email address should be downcase" do
       mixed_case_email = "FOdf@ELJ.cOM"
       @user.email = mixed_case_email
       @user.save  # Running the test won't change the database
       assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = ""
    assert_not @user.valid?
  end

  test "password should longer than 6" do
     @user.password = @user.password_confirmation = "3"*5
    assert_not @user.valid?
  end


end
