class ContactUs < ActionMailer::Base
  default from: "shnackapp@gmail.com"


  def email_shnack(name, email, message)

  	@customer_name = name
  	@customer_email = email
  	@customer_message = message
	mail(to: "brock@shnackapp.com", subject: "Message from #{@customer_name} via Contact Us")

  end
end
