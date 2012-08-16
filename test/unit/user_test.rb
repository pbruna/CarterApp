require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(:email => "test@example.com", :password => "123456")
    @user.save    
  end
  
  test "new user must have a trial plan" do
    assert_equal(User::PLANS[:trial][:id], @user.plan_id)
  end
  
  test "#payment_day must be the same number of the day the account was created" do
    assert_equal(@user.created_at.day, @user.payment_day)
  end
  
  test "sasl_login must the email with @ replaced by _ on create" do
    modified_email = "test_example.com"
    assert_equal(modified_email, @user.sasl_login)
  end
  
  test "sasl_password must be equal to sasl_password_view in md5" do
    md5_password = Digest::MD5.hexdigest(@user.sasl_password_view)
    assert_equal(md5_password, @user.sasl_password)
  end
  
end
