# encoding: UTF-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(:email => "test@example.com", :password => "123456", :account_name => "IT Linux")
    @user.save    
  end
  
  test "new user must no be create if the account already exist" do
    user2 = User.new(:email => "test2@example.com", :password => "123456", :account_name => "IT Linux")
    assert(!user2.save, "Failure message.")
  end
  
  test "new user must create an account" do
    assert_equal("IT Linux", @user.account.name)
  end
  
  test "user must be the owner of the account" do
    account = Account.find(@user.account_id)
    assert_equal(@user.id, account.owner_id)
  end
  
   
  
end
