require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @account = Account.new(:name => "Example.com")
    @account.users.build(:email => "test@example.com", :password => "mdakndkajdn")
    @account.save
  end

  test "should no be possible to delete the owner user" do
    user = @account.owner
    assert(!user.destroy, "User destroyed anyway")
  end
  
  test "after create an user an email should be sent" do
    assert(!ActionMailer::Base.deliveries.empty?, "No email in queue.")
    email = ActionMailer::Base.deliveries.last
    assert_equal([@account.owner.email], email.to)
  end
  
  test "after create the user should have a reset_password_token" do
    user = @account.owner
    assert_not_nil(user.reset_password_token)
  end

end
