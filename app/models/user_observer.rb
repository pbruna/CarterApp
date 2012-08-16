class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user = User.find(user)
    UserMailer.delay.welcome_email(user) # We use delayed_job
  end
end