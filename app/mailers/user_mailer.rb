class UserMailer < ActionMailer::Base
  default from: "shnackapp@gmail.com"

  def welcome_email(user)
  	@user = user
  	@url = 'https://www.gem.shnackapp.com/users/sign_in'
  	mail(to: @user.email, subject: "Welcome to Shnack")
  end

  def announcement_email(user)
    @user = user
    @bb_url = 'https://shnackapp.com/orders/new?restaurant_id=2'
    attachments.inline["BuddhaBowlsNow.png"] = File.read(Rails.root.join('public/images/BuddhaBowlsNow.png'))  
    mail(to: @user.email, subject: "Shnack is now coming to Buddha Bowls!!")
  end

end
