class RestaurantsController < ApplicationController
	before_filter :check_manager 

	def index
	  	@restaurants = Restaurant.all
	end
	def show
		@restaurant = Restaurant.find(params[:id])
		@amount = @restaurant.available_amount
		@account = @restaurant.bank_account_id.nil? ? nil : Stripe::Recipient.retrieve(@restaurant.bank_account_id).active_account
		@transfer =  @restaurant.transfers.length > 0 ?  Stripe::Transfer.retrieve(@restaurant.transfers.last.transfer_id) : nil
	end

	def new
		@restaurant = Restaurant.new
		i=0
		while i <= Hour.saturday 
			hours = @restaurant.hours.where(:day => i).first_or_create
			hours.opening_time = '0000'
			hours.closing_time = '0000'
			hours.save
			i=i+1
		end
	end

	def analytics
		## AVERAGE ORDER SIZE##
		total = 0
		@restaurant = Restaurant.find(params[:id])
		@orders = @restaurant.orders
		count = @orders.count
		@orders.each do |ord|
			total = total + ord.total
		end
		total = total/count
		@avg_total = integer_to_currency(total)


		##TOP 5 ITEMS ORDERED##
		ord_num = []
		@orders.each do |ord|
			ord_num.push(ord.id)
		end
		order_item = []
		ord_num.each do |on|
			order_item.push(Item.find(OrderItem.find(on).item_id).name)
		end
		@order_hash = Hash.new(0)
		order_item.each do |v|
			@order_hash[v] += 1
		end
		o_hash = @order_hash.sort_by { |name, qty| qty }.reverse
		o_hash = o_hash.take(5)
		@order_hash = o_hash.inject({}) do |r, s|
  			r.merge!({s[0] => s[1]})
  		end

  		## Average ORDER TIME##
  		@avg_time = 0
  		@orders.each do |ord|
  			@avg_time+=((ord.updated_at-ord.created_at)/60)
  		end
  		@avg_time = (@avg_time/count).round(2)

  		## Users created ##
  		@user_count = User.count(:group => 'date(created_at)')

  		## DAILY ORDERS ##
  		@daily_ord = @orders.count(:group => 'date(created_at)')
	end

	def recent_orders
		@restaurant = Restaurant.find(params[:id])
		@orders = @restaurant.orders

	end

	def edit
		@restaurant = Restaurant.find(params[:id])
	end

	def update
		@restaurant = Restaurant.find(params[:id])
		hours_params = params[:restaurant].delete(:hours)
		i = 0
		
		while i <= Hour.saturday 
			hours = @restaurant.hours.where(:day => i).first_or_create
			hours.opening_time = hours_params[i.to_s][:open]
			hours.closing_time = hours_params[i.to_s][:close]
			hours.save
			i = i + 1
		end
		

		@restaurant.update_attributes(params[:restaurant])
		redirect_to @restaurant
	end


	def create

		hours_params = params[:restaurant].delete(:hours)
		@restaurant = Restaurant.create(params[:restaurant])

		i = 0
		while i <= Hour.saturday 
			hours = @restaurant.hours.where(:day => i).first_or_create
			hours.opening_time = hours_params[i.to_s][:open]
			hours.closing_time = hours_params[i.to_s][:close]
			i = i + 1
		end

		
		@menu = Menu.create
		@menu.restaurant = @restaurant
		@menu.save

		@restaurant.generate_registration_code
		@restaurant.save
		
		redirect_to @restaurant
	end

	def destroy
		Restaurant.find(params[:id]).destroy
		redirect_to :action => :index
	end

	def bank_account
		@restaurant = Restaurant.find(params[:id])
		# @recipient = Stripe::Recipient.retrieve(@restaurant.bank_account_id) unless @restaurant.bank_account_id.nil?
	end
	
	def save_bank_account
		@restaurant = Restaurant.find(params[:id])
		
		if @restaurant.bank_account_id.nil?		
			recipient = Stripe::Recipient.create(
	  			:name => params[:name],
	  			:type => params[:account],
	  			:email => current_user.email,
	  			:bank_account => params[:stripeToken]
			)
			@restaurant.update_attribute(:bank_account_id, recipient.id)

		else
			recipient = Stripe::Recipient.retrieve(@restaurant.bank_account_id)
			recipient.bank_account = params[:stripeToken]
			recipient.save
		end
		redirect_to @restaurant
	end

	def add_manager
		@restaurant = Restaurant.find(params[:id])
		@user = User.where(:email => params[:email]).first
		@role = @user.role

		@role.update_attribute(:role_type, 1)

		@restaurant.roles << @role

		redirect_to @restaurant
	end

	def withdraw_funds
		@restaurant = Restaurant.find(params[:id])

		if @restaurant.bank_account_id.nil?
			flash[:error] = "Please set up a bank account with Shnack before attempting to withdraw funds"
		else
			# Check if account has the funds to handle withdrawal.
			# flash[:error] = "There was a problem. Please contact us at contact@shnackapp.com for assistance."

			stripe_transfer = Stripe::Transfer.create(
  				:amount => @restaurant.available_amount, # amount in cents
  				:currency => "usd",
  				:recipient => @restaurant.bank_account_id,
  				:statement_description => "Transfer on date"
			)

			transfer = @restaurant.transfers.create(:transfer_id => stripe_transfer.id)
		
			mark_available_orders_as_withdrawn(@restaurant, transfer)
			flash[:notice] = "Funds are currently being transferred."
			
		end

		redirect_to @restaurant

		rescue	Stripe::InvalidRequestError => e
			flash[:error] = e.message
			redirect_to @restaurant
	end

	def new_registration_code
		@restaurant = Restaurant.find(params[:id])

		@restaurant.generate_registration_code
		@restaurant.save

		redirect_to @restaurant
	end

	def check_manager
		redirect_to root_path unless user_signed_in? && (current_user.is_super? || current_user.is_manager_of?(Location.find(params[:id])))
	end

end
