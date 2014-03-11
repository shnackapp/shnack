module ApiHelper
	def notify_user_of_completed_order(order)


	  	@client = Twilio::REST::Client.new Rails.configuration.twilio[:sid], Rails.configuration.twilio[:token] 

	  	unless order.user.nil?
		  	@client.account.messages.create({
				:from => Rails.configuration.twilio[:from],
				:to => order.user.number,
		  		:body => "Your order ##{order.id} at #{order.owner.name} is ready to be picked up."    
		  	})
		end


	end
end
