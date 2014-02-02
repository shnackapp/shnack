class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
  	@user = user
  	@url = 'http://192.168.163.129:3000/users/sign_in'
  	mail(to: @user.email, subject: "Welcome to Shnack")
  end
end