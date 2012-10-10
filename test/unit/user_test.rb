require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def teardown
    Account.delete_all
    User.delete_all
  end

  test "should no be possible to delete the owner user" do
    account = Account.new(:name => "Example.com")
    account.users.build(:email => "test@example.com", :password => "mdakndkajdn")
    account.save
    user = User.find_by(email: "test@example.com")
    assert(!user.destroy, "User destroyed anyway")
  end


end
