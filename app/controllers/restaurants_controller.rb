class RestaurantsController < ApplicationController
	before_filter :check_manager

	def index
	  	@restaurants = Restaurant.all
	end
	def show
		@restaurant = Restaurant.find(params[:id])
		@amount = 0
		@restaurant.orders.available.each { |order| @amount = @amount + order.location_cut unless order.location_cut.nil? }

		@account = @restaurant.bank_account_id.nil? ? nil : Stripe::Recipient.retrieve(@restaurant.bank_account_id).active_account

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
		end
		redirect_to @restaurant
	end


	def withdraw_available_funds

	end

	def new_registration_code
		@restaurant = Restaurant.find(params[:id])

		@restaurant.generate_registration_code
		@restaurant.save

		redirect_to @restaurant
	end

	def check_manager
		redirect_to root_path unless user_signed_in? && current_user.is_super
	end

end
