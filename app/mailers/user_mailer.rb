class UserMailer < ActionMailer::Base
  default from: "shnackapp@gmail.com"

  def welcome_email(user)
  	@user = user
  	@url = 'https://www.shnackapp.com/users/sign_in'
  	mail(to: @user.email, subject: "Welcome to Shnack")
  end
end