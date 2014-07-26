class ApiController < ApplicationController
	include ApiHelper
	# http_basic_authenticate_with name: "admin", password: "secret"

	before_filter :restrict_access
	respond_to :json

	def create
    @user = User.create(:name => params[:name],:email => params[:email],:phone => params[:phone],:password => params[:password])

   	#respond_with  {:auth_token => @user.authentication_token}
   	   	respond_with  {auth_token:@user.authentication_token}




    # respond_to do |format|
    #   if @user.save
    #     # Tell the UserMailer to send a welcome Email after save
    #     UserMailer.welcome_email(@user).deliver
 
    #     format.html { redirect_to(@user, notice: 'User was successfully created.') }
    #     format.json { render json: @user, status: :created, location: @user }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

	def index
		respond_with User.all
	end

	def get_locations
		respond_with Location.all.map { |loc| {:id => loc.id, :name => loc.name, :has_children => loc.has_children} }
	end

	def get_vendor_for_location
	    @loc = Location.find(params[:object_id])
	    if @loc.instance_of?(Restaurant)
	      redirect_to new_order_path(:restaurant_id => @loc.id) 
	    else
	  		respond_with @loc.vendors
	    end
	end



	# HTTP Request for when the device turns on and sends in it's device token
	def send_device_token
		@device = Device.where(:token =>params[:device_token])
		
		if @device.length > 0 && (!@device.first.vendor.nil? || !@device.first.restaurant.nil?)
			d = @device.first
			render :json => { :vendor_id => d.owner.id, :initial_state => d.owner.initial_state }
		else
			render :json => {:error => "unregistered_device", :token => params[:device_token]}
		end
	end

	def get_open_orders
		@device = Device.where(:token =>params[:device_token]).first
		@owner = @device.owner
		@orders = @owner.open_orders
		@result = @orders.map { |o| {:id => o.id, :order_number => o.order_number, :name => o.customer.name, :number => o.customer.number, :created_at => o.created_at.strftime("%Y-%m-%d %H:%M:%S %z"),  :details => o.description, :state => o.current_order_state.state}} 

		respond_with @result, :location => nil
	end


	def get_past_orders
		@device = Device.where(:token => params[:device_token]).first
		@owner = @device.owner

		@orders = @owner.past_orders
		@result = @orders.map { |o| {:id => o.id, :order_number => o.order_number, :name => o.customer.name, :number => o.customer.number,  :created_at => o.created_at.strftime("%Y-%m-%d %H:%M:%S %z"),  :details => o.description, :state => o.current_order_state.state}} 

		respond_with @result, :location => nil
	end


	def get_menu_for_vendor
	@vendor = Vendor.find(params[:object_id])
    respond_with @vendor.menu.items
	end


	def get_menu_for_vendor
		unless params[:device_token].nil?
			@device = Device.where(:token => params[:device_token]).first
			@owner = @device.owner
		else
			@owner = Vendor.exists?(params[:object_id]) ? Vendor.find(params[:object_id]) : Restaurant.find(params[:object_id])
		end
		# respond_with {:error => "Please create a menu at #{request.domain}"}, :location=>nil if @menu.nil?


		@menu = @owner.menu
		@categories = @menu.categories

		respond_with @categories.map { |cat| {:name => cat.name, :items => cat.items} }, :location => nil
	end

	# Register a device token with a vendor
	def register_device_token_for_vendor
		@owner = Vendor.where(:registration_code => params[:registration_code]).first
		@owner = Restaurant.where(:registration_code => params[:registration_code]).first if @owner.nil?

		# render :json => { :error => "incorrect_registration_code" } if @owner.nil? 

		@device = Device.where(:token => params[:device_token]).first_or_create
		@device.update_owner @owner
		@device.save
		render :json => @device
	end

	# Unregister a device token with a vendor
	def unregister_device
		@device = Device.where(:token => params[:device_token]).first
		@device.vendor = nil
		@device.restaurant = nil
		@device.save

		respond_with @device, :location => nil
	end


	def update_order_state
		@order = Order.find(params[:order_id])
		render :json => { :error => "Order not found in table" } if @order.nil?

		@order_state = @order.update_state

		@order.notify_customer_of_completed_order if @order_state.state == 2

		render :json => @order_state
	end

	# Post request to log a user in.
	# If the user is successfully logged in, it sends back the users authentication token
	def login
		@user = User.where(:email => params[:email]).first
		@response = Hash.new

		if @user
			if @user.valid_password?(params[:password])
				@response[:auth_token] =  @user.authentication_token
			else
				@response[:error] = "incorrect_password"
			end
		else
			@response[:error] = "incorrect_email"
		end

		respond_with(@response, :location => nil)
	end

	def toggle_item_sold_out
		@item = Item.find(params[:item_id])
		if @item.nil?
			render :json => {:error => "Item not found"}
		else
			@item.update_attribute(:sold_out, !@item.sold_out)
			render :json => {:success => "success", :item_id => @item.id, :sold_out => @item.sold_out }
		end
	end


	def vendors_by_user_token
		@user = User.where(:authentication_token => params[:auth_token]).first
		if @user.is_super
			@vendors = Vendor.all
		else
			@vendors = Vendor.where(:roles => {:id => @user.role.id})

		end
		render :json => @vendors
	end

	

	def customer
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here https://dashboard.stripe.com/account
		Stripe.api_key = 'sk_test_xDJ5KS0I8VgJvHSQT1Iuxy56'
		# Get the credit card details submitted by the form

		begin

		@customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :card  => params[:stripeToken]
	    )

# Use Stripe's bindings...
rescue Stripe::CardError => e
# Since it's a decline, Stripe::CardError will be caught
	body = e.json_body
	err  = body[:error]
	puts "Status is: #{e.http_status}"
	puts "Type is: #{err[:type]}"
	puts "Code is: #{err[:code]}"
	# param is '' in this case
	puts "Param is: #{err[:param]}"
	puts "Message is: #{err[:message]}"
rescue Stripe::InvalidRequestError => e
# Invalid parameters were supplied to Stripe's API
	body = e.json_body
	err  = body[:error]
	puts "Status is: #{e.http_status}"

rescue Stripe::AuthenticationError => e
# Authentication with Stripe's API failed
# (maybe you changed API keys recently)
rescue Stripe::APIConnectionError => e
# Network communication with Stripe failed
rescue Stripe::StripeError => e
# Display a very generic error to the user, and maybe send
# yourself an email
rescue => e
# Something else happened, completely unrelated to Stripe
end

render :json => @customer

end


	private
	# SHOULD BE PRIVATE BUT BREAKS IF I MAKE IT SO (unexpected keyword end when surrounding with private ... end)
	def restrict_access
		# api_key = ApiKey.find_by_access_token(params[:access_token])
		# head :unauthorized unless api_key

		authenticate_or_request_with_http_token do |token, options|
			ApiKey.exists?(:access_token => token)
		end
	end

	# def payment_params
 #      params.require(:stripeToken).permit(:amount)
 #  	end
end
