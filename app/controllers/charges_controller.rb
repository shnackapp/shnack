class ChargesController < ApplicationController
	include ChargesHelper

	def index
			respond_with "Hello"
	end

	def new
		@order = Order.includes(:order_items).find(params[:order_id], :include => {:vendor => {:menu => :items}})
		# if the order has already been paid for, 
		redirect_to order_path(@order) if @order.paid

		@owner = @order.owner
		@items = Hash[@order.owner.menu.items.map{|it| [it.id, it]}]
		@order_items = @order.order_items
	end

	def create
	  # Amount in cents

	  @order = Order.find(params[:order_id])
	  @amount = @order.total
	  @owner = @order.owner



	  unless @owner.is_open?
	  	redirect_to root_path 
	  	return
	  end
	  
	  if @order.paid
	  	redirect_to order_path(@order)
	  	return
	  end




	  if @order.user.nil?
	  	@order.user_info.update_attributes(:email => params[:stripeEmail], :number => params[:user][:phone])
	  else
	  	@order.user.update_attributes(:number => params[:user][:phone])
	  end

	  if @owner.cash_only
	  	@order.update_attribute(:paid, true)
	  else

	  	unless @order.user.nil?
		  customer = Stripe::Customer.create(
		    :email => params[:stripeEmail],
		    :card  => params[:stripeToken]
		  )

		  @order.user.update_attribute(:customer_id, customer.id)

		  charge = Stripe::Charge.create(
		    :customer    => customer.id,
		    :amount      => @amount,
		    :description => 'Rails Stripe customer',
		    :currency    => 'usd'
		  )
	      @order.update_attribute(:paid, true)
	  	else
	  	  charge = Stripe::Charge.create(
    		:amount => @amount, # amount in cents, again
    		:currency => "usd",
    		:card => params[:stripeToken],
    		:description => params[:stripeEmail]
  			)
	  	end


	  end


  	# An example of the token sent back when a device registers for notifications
    # token = "<2410d83b 257e501b 73cb9bc6 c44a9b4e fa46aab1 99694c8e fb01088c 3c5aca75>"
    # byebug
   	  @owner.devices.each { |d|
   	  	
	    order_description = @order.description

	    # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
	    notification = Houston::Notification.new(device: d.token)
	    notification.alert = "New order made!"
	    notification.sound = "Glass.aiff"
	    notification.badge = 1

	    notification.content_available = true
	    notification.custom_data = {order_number: @order.order_number, order_description: order_description, pay_with_cash: @owner.cash_only ,order_created_at: @order.created_at.strftime("%Y-%m-%d %H:%M:%S %z")  }

	    # And... sent! That's all it takes.
	    APN.push(notification)
 
      }


	  @order.order_states.create(:state => 0)
	  #send User an email letting them know their order has been placed
	  ReceiptMailer.receipt_email(@order).deliver unless @order.customer.email.nil?

	  redirect_to order_path(@order)
	
	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end

end
