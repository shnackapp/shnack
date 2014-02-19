class ChargesController < ApplicationController

	def new
		@order = Order.find(params[:order_id], :include => {:vendor => {:menu => :items}})
		@vendor = @order.vendor
		@items = Hash[@order.vendor.menu.items.map{|it| [it.id, it]}]
		@order_details = parse_order_details @order.details
	end

	def create
	  # Amount in cents

	  @order = Order.find(params[:order_id])
	  @order.order_states.create(:state => 0)
	  @amount = @order.amount
	  @vendor = @order.vendor

	  customer = Stripe::Customer.create(
	    :email => 'anshul.jain242@gmail.com',
	    :card  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer',
	    :currency    => 'usd'
	  )

  	# An example of the token sent back when a device registers for notifications
    # token = "<2410d83b 257e501b 73cb9bc6 c44a9b4e fa46aab1 99694c8e fb01088c 3c5aca75>"
    # byebug
   	  @vendor.devices.each { |d|

	    order_details = parse_order_details(@order.details)
	    order_description = convert_details_to_description(order_details)

	    # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
	    notification = Houston::Notification.new(device: d.token)
	    notification.alert = "New order made!"

	    # Notifications can also change the badge count, have a custom sound, indicate available Newsstand content, or pass along arbitrary data.
	    # notification.badge = 57
	    # notification.sound = "sosumi.aiff"
	    notification.content_available = true
	    notification.custom_data = {order_number: @order.id, order_description: order_description, order_created_at: @order.created_at.strftime("%Y-%m-%d %H:%M:%S %z")  }

	    # And... sent! That's all it takes.
	    APN.push(notification)
 
      }
	  #send User an email letting them know their order has been placed

	
	  redirect_to order_path(@order)
	
	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end

end
