class ContactUs < ActionMailer::Base
  default from: "shnackapp@gmail.com"


  def email_shnack(params)

  	@customer_name = params[:cust_name]
  	@customer_email = params[:cust_email]
  	@customer_restaurant = params[:cust_restaurant]
  	@customer_number = params[:cust_number]
	mail(to: "brock@shnackapp.com", subject: "Interested restaurant from #{@customer_name} via Contact Us")

  end
end
