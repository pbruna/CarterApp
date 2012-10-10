require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  def teardown
    Account.delete_all
    User.delete_all
  end

  test "should register account and user" do
    account = {:name => "Example.com"}
    account[:users_attributes] = {"0" => {:email => "test@example.com", :password => "83838393", "password_confirmation" => "83838393"}}
    assert_difference "Account.count", +1 do
      post :create, :account => account
    end
    assert_redirected_to account_path(assigns(:account))
  end

  # test "the truth" do
  #   assert true
  # end
end
