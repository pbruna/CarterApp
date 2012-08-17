# encoding: UTF-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(:email => "test@example.com", :password => "123456", :account_name => "IT Linux")
    @user.save    
  end
  
  test "new user must no be create if the account already exist" do
  end
  
  test "new user must create an account" do
    assert_equal("IT Linux", @user.account.name)
  end
  
   
  
end
