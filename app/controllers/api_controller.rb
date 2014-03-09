class ApiController < ApplicationController
	# http_basic_authenticate_with name: "admin", password: "secret"
	before_filter :restrict_access

	respond_to :json
	def index
		respond_with User.all
	end

<<<<<<< HEAD

	# HTTP Request for when the device turns on and sends in it's device token
	def send_device_token
		@device = Device.where(:token =>params[:device_token])
		if @device.length > 0 && !@device.first.vendor.nil?
			render :json => @device.first
		else
			render :json => {:error => "unregistered_device", :token => params[:device_token]}
		end
	end

	def get_open_orders
		@device = Device.where(:token =>params[:device_token]).first
		@vendor = @device.vendor
		@orders = @vendor.open_orders
		@result = @orders.map { |o| {:id => o.id, :created_at => o.created_at.strftime("%Y-%m-%d %H:%M:%S %z"),  :details => o.description, :state => o.current_order_state.state}} 

		respond_with @result, :location => nil
	end

	# Register a device token with a vendor
	def register_device_token_for_vendor
		@vendor = Vendor.where(:registration_code => params[:registration_code]).first
		render :json => { :error => "incorrect_registration_code" } if @vendor.nil? 

		@device = Device.where(:token => params[:device_token]).first_or_create
		@device.vendor = @vendor
		@device.save
		render :json => @device
	end

	# Unregister a device token with a vendor
	def unregister_device
		@device = Device.where(:token => params[:device_token]).first
		@device.vendor = nil
		@device.save

		respond_with @device, :location => nil
	end


	def update_order_state
		@order = Order.find(params[:order_id])
		render :json => { :error => "Order not found in table" } if @order.nil?

		@order.update_state

		render :json => @order.current_order_state

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


	def vendors_by_user_token
		@user = User.where(:authentication_token => params[:auth_token]).first
		if @user.is_super
			@vendors = Vendor.all
		else
			@vendors = Vendor.where(:roles => {:id => @user.role.id})

		end
		render :json => @vendors
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
end
