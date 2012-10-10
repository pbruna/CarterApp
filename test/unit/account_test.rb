require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  def teardown
    Account.delete_all
    User.delete_all
  end

  test "new account must have an owner" do
    @account = Account.new(:name => "Example.com")
    user = @account.users.build
    user.email = "test@example.com"
    user.password = "73737373"
    assert(@account.save, "No se guardo")
    assert_equal(@account.owner.id, @account.users.first.id)
  end
  
end
