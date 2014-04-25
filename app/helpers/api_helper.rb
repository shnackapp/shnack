module ApiHelper
	def notify_user_of_completed_order(order)


	  	@client = Twilio::REST::Client.new Rails.configuration.twilio[:sid], Rails.configuration.twilio[:token] 

	  	unless order.user.nil?
		  	@client.account.messages.create({
				:from => Rails.configuration.twilio[:from],
				:to => order.user.number,
		  		:body => "Your order ##{order.order_number} at #{order.owner.name} is ready to be picked up at the table underneath the overhead. Thanks for ordering! Team Shnack - Table 4"    
		  	})
		end


	end
end
