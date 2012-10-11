ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  teardown :global_teardown
  
  def global_teardown
    Account.delete_all
    User.delete_all
  end
  
end

class ActionController::TestCase
  include Devise::TestHelpers
end
