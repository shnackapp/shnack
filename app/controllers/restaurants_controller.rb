class RestaurantsController < ApplicationController
	before_filter :check_manager

	def index
	  	@restaurants = Restaurant.all
	end
	def show
		@restaurant = Restaurant.find(params[:id])

		unless @restaurant.recipient_id.nil?
		transfer = Stripe::Transfer.create(
			:amount => 1000, # amount in cents
			:currency => "usd",
			:recipient => @restaurant.recipient_id,
			:statement_description => "JULY SALES"
			) 

		end



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

	def bank_details
		@restaurant = Restaurant.find(params[:id])

	end

	def update_bank_details
		@restaurant = Restaurant.find(params[:id])

		recipient = Stripe::Recipient.create(
  			:name => params[:bank_account][:legal_name],
  			:type => "corporation",
  			:tax_id => params[:bank_account][:ein],
  			:bank_account => params[:bank_account][:stripe_token]
		)

		byebug

		@restaurant.recipient_id = recipient.id
		@restaurant.save




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
