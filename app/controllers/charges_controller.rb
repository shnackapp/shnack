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
	  @order = Order.find(params[:order_id])
	  @amount = @order.total 	  # Amount in cents
	  @owner = @order.owner



	  unless @owner.is_open?
	  	flash[:error] = "#{@owner.name} is currently closed. Sorry for the inconvenience."
	  	redirect_to root_path 
	  	return
	  end
	  
	  if @order.paid
	  	flash[:error] = "Somebody has already paid for this order!"
	  	redirect_to order_path(@order)
	  	return
	  end


	  #If the user is not signed in
	  # Then they're creating an account
	  unless user_signed_in?
	  	if User.where(:email=>params[:user][:email]).count > 0
	  		flash[:error] = "E-mail address is already taken"
	  		redirect_to new_order_charge_path @order
	  		return
	  	else
	  		@user = User.new(:email => params[:user][:email], 
	  						:password => params[:user][:password],
	  						:password_confirmation => params[:user][:password],
	  						:number => params[:user][:phone],
	  						:name => params[:user][:name])
	  		sign_in @user
	  	end
	  else 
	  	current_user.update_attributes(params[:user])
	  end

	  if @owner.cash_only
	  	@order.update_attribute(:paid, true)
	  	@owner.user = current_user
	  	@order.shnack_cut = 0
	  	@order.location_cut = 0
	  	@order.withdrawn = true
	  else

	  	# If they selected an already created card
  	  	if(params[:stripeCardIndex])

	  	  	customer = Stripe::Customer.retrieve(current_user.customer_id)
	  	  	charge = Stripe::Charge.create(
	  	  		:customer => customer.id,
	  	  		:card => customer.cards.data[params[:stripeCardIndex].to_i].id,
	  	  		:amount => @amount,
	  	  		:description => "Shnack Order ##{@order.order_number}",
	  	  		:currency => 'usd'
	  	  		)
		  	flash[:notice] = "Your order was placed successfully. You will receive a text when your order is ready. Thank you for using Shnack!"
	  	  	@order.update_attributes(:charge_id => charge.id, :paid => true, :user_id => current_user.id)
  	  	else # if they are creating a new card
  	  		user = current_user
  	  		if user.customer_id.nil? #if they have no past credit cards.
  	  			customer = Stripe::Customer.create(
		    		:email => current_user.email,
		    		:card  => params[:stripeToken]
		  		)

		  		card = customer.cards.data.last
		  		current_user.update_attribute(:customer_id, customer.id)
		  	else #If they already have past credit cards, add it to their customer.
		  		customer = Stripe::Customer.retrieve(user.customer_id)
		  		card = customer.cards.create(:card => params[:stripeToken])
		  	end

		  	charge = Stripe::Charge.create(
		    	:customer    => customer.id,
		    	:card => card.id,
		    	:amount      => @amount,
		    	:description => "Shnack Order ##{@order.order_number}",
		    	:currency    => 'usd'
		  	)

      		flash[:notice] = "Your order was placed successfully. You will receive a text when your order is ready. Thank you for using Shnack"
		  	@order.update_attributes(:charge_id => charge.id, :paid => true, :user_id => current_user.id)
		end




		@order.shnack_cut = @owner.shnack_fee + @owner.shnack_percent * @order.subtotal/100
		@order.location_cut = @order.total - @order.shnack_cut

	  end


	  @order.save

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
	    notification.custom_data = {order_number: @order.order_number, order_description: order_description, 
	    			pay_with_cash: @owner.cash_only ,order_created_at: @order.created_at.strftime("%Y-%m-%d %H:%M:%S %z"), :name => @order.customer.name, :number => @order.customer.number  }

	    # And... sent! That's all it takes.
	    APN.push(notification)
 
      }


	  @order.order_states.create(:state => @owner.initial_state)
	  #send User an email letting them know their order has been placed
	  ReceiptMailer.receipt_email(@order).deliver unless @order.customer.email.nil?

	  redirect_to order_path(@order)
	
	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end


end
