class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def welcome_email(user)
    mail(:to => user.email, :subject => "Bienvenido a Carter")
  end
  
end