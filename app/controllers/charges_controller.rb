class ChargesController < ApplicationController


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
	  	@user = User.where(:email => params[:user][:email]).first_or_create
	  	@user.password = "temppassword"
	  	@user.number = params[:user][:phone]
	  	@user.save
	  	
	  	#Create role
	  	role = Role.create(:role_type => 0)
	  	role.user = @user
	  	role.save

	  	#save order
	  	@order.user = @user
	  	@order.save
	  else
	  	if User.exists?(:email => params[:user][:email])
	  		@user = User.where(:email => params[:user][:email]).first
	  		@user.update_attribute(:number, @order.user.number)
	  		@order.user = @user
	  		@order.save
	  	else
	  		@order.user.update_attribute(:email, params[:user][:email])
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
	    notification.custom_data = {order_number: @order.order_number, order_description: order_description, order_created_at: @order.created_at.strftime("%Y-%m-%d %H:%M:%S %z")  }

	    # And... sent! That's all it takes.
	    APN.push(notification)
 
      }

	  @order.order_states.create(:state => 0)
      @order.update_attribute(:paid, true)
	  #send User an email letting them know their order has been placed
	  ReceiptMailer.receipt_email(@order).deliver

	  redirect_to order_path(@order)
	
	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end

end
