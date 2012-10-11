class UserMailer < ActionMailer::Base
  
  def welcome_email(record)
    @user = record
    mail(:to => @user.email, :subject => "Bienvenido a CarterApp")
  end
  
end