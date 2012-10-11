require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  def setup
    @account = Account.new(:name => "Example.com", :root => true)
    user = @account.users.build
    user.email = "test@example.com"
    user.password = "73737373"
  end

  test "new account must have an owner" do
    assert(@account.save, "No se guardo")
    assert_equal(@account.owner.id, @account.users.first.id)
  end
  
  test "ROOT account should not be deleted" do
    @account.root = true
    assert(@account.save, "No se guardo")
    assert(!@account.destroy, "Should not be deleted")
  end
  
  
end
