require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "welcome_email content" do
    user = User.new(email: "test@example.com", :password => "ajdkandka")
    user.save
    email = UserMailer.welcome_email(user).deliver
    assert(!ActionMailer::Base.deliveries.empty?, "Failure message.")
    
    assert_equal("Bienvenido a CarterApp", email.subject)
    assert_equal(["no-reply@carterapp.com"], email.from)
    assert_match(/reset_password_token/, email.encoded)
    
  end

end
