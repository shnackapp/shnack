module ApiHelper
	def notify_user_of_completed_order(order)


	  	@client = Twilio::REST::Client.new Rails.configuration.twilio[:sid], Rails.configuration.twilio[:token] 

	  	customer = order.customer

	  	unless customer.nil?
		  	@client.account.messages.create({
				:from => Rails.configuration.twilio[:from],
				:to => customer.number,
		  		:body => "Your order ##{order.order_number} at #{order.owner.name} is ready to be picked up."    
		  	})
		end
	end
end
