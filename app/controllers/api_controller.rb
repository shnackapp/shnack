class ApiController < ApplicationController
	include ApiHelper
	# http_basic_authenticate_with name: "admin", password: "secret"
	before_filter :restrict_access

	respond_to :json
	def index
		respond_with User.all
	end

	# HTTP Request for when the device turns on and sends in it's device token
	def send_device_token
		@device = Device.where(:token =>params[:device_token])
		
		if @device.length > 0 && (!@device.first.vendor.nil? || !@device.first.restaurant.nil?)
			render :json => @device.first
		else
			render :json => {:error => "unregistered_device", :token => params[:device_token]}
		end
	end

	def get_open_orders
		@device = Device.where(:token =>params[:device_token]).first
		@owner = @device.owner
		@orders = @owner.open_orders
		@result = @orders.map { |o| {:id => o.order_number, :created_at => o.created_at.strftime("%Y-%m-%d %H:%M:%S %z"),  :details => o.description, :state => o.current_order_state.state}} 

		respond_with @result, :location => nil
	end


	def get_past_orders
		@device = Device.where(:token => params[:device_token]).first
		@owner = @device.owner

		@orders = @owner.past_orders
		@result = @orders.map { |o| {:id => o.id, :created_at => o.created_at.strftime("%Y-%m-%d %H:%M:%S %z"),  :details => o.description, :state => o.current_order_state.state}} 

		respond_with @result, :location => nil
	end


	def get_menu_for_vendor
		@device = Device.where(:token => params[:device_token]).first
		@owner = @device.owner
		@menu = @owner.menu
		# respond_with {:error => "Please create a menu at #{request.domain}"}, :location=>nil if @menu.nil?

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

		notify_user_of_completed_order @order if @order_state.state == 2

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
