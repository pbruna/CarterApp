# encoding: UTF-8
require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  
  def setup
    @account = Account.new(:name => "IT Linúx")
    @account.save
  end
  
  test "new user must have a trial plan" do
     assert_equal(Account::PLANS[:trial][:id], @account.plan_id)
   end
  
   test "#payment_day must be the same number of the day the account was created" do
     assert_equal(@account.created_at.day, @account.payment_day)
   end
   
   test "account must be active" do
    assert(@account.active?, "Failure message.")
   end
  
   test "sasl_login must the name without spaces" do
     modified_email = "itlinux"
     assert_equal(modified_email, @account.sasl_login)
   end
  
   test "sasl_password must be equal to sasl_password_view in md5" do
     md5_password = Digest::MD5.hexdigest(@account.sasl_password_view)
     assert_equal(md5_password, @account.sasl_password)
   end
end
