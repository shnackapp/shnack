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
	  @amount = @order.amount


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
	
	  redirect_to order_path(@order)
	
	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end

end
