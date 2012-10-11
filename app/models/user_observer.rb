class UserObserver < Mongoid::Observer
  def after_create(user)
    UserMailer.delay.welcome_email(user) # We use delayed_job
  end
end