class ApiController < ApplicationController
	include ApiHelper
	# http_basic_authenticate_with name: "admin", password: "secret"

	before_filter :restrict_access
	respond_to :json

	### Create with User with Customer id from Stripe ###
	def create
    @user = User.create(:name => params[:name],:email => params[:email],:number => params[:phone],:password => params[:password],:customer_id =>params[:customer_id])
    #@user = User.create(user_params)
   	#respond_with  {:auth_token => @user.authentication_token}
   	respond_with(@user.authentication_token, @user.id,:location =>nil)
   	
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

  def unique_email_phone
  	puts params[:email]
  	puts params[:phone]

  	email_exists = User.where(email: params[:email]).exists? 
  	phone_exists = User.where(number: params[:phone]).exists? 
  	puts email_exists.to_s
  	puts phone_exists.to_s
  	render json: { email_exists: email_exists.to_s, phone_exists: phone_exists.to_s}
  end

	def index
		respond_with User.all
	end
	### Customer ###
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

	### Vendor ###
	# HTTP Request for when the device turns on and sends in it's device token
	def send_device_token
		@device = Device.where(:token =>params[:device_token])
		
		if @device.length > 0 && (!@device.first.vendor.nil? || !@device.first.restaurant.nil?)
			d = @device.first
			render :json => { :vendor_name => d.owner.name, :vendor_id => d.owner.id, :initial_state => d.owner.initial_state, :is_open => d.owner.open }
		else
			render :json => {:error => "unregistered_device", :token => params[:device_token]}
		end
	end

	### Vendor ###
	def get_open_orders
		@device = Device.where(:token =>params[:device_token]).first
		@owner = @device.owner
		@orders = @owner.open_orders
		@result = @orders.map { |o| {:id => o.id, :order_number => o.order_number, :name => o.customer.name, :number => o.customer.number, :created_at => o.order_states.where(:state => 0).first.created_at.strftime("%Y-%m-%d %H:%M:%S %z"),  :details => o.description, :state => o.current_order_state.state}} 

		respond_with @result, :location => nil
	end

	### Vendor ###
	def get_past_orders
		@device = Device.where(:token => params[:device_token]).first
		@owner = @device.owner

		@orders = @owner.past_orders
		@result = @orders.map { |o| {:id => o.id, :order_number => o.order_number, :name => o.customer.name, :number => o.customer.number,  :created_at => o.order_states.where(:state => 0).first.created_at.strftime("%Y-%m-%d %H:%M:%S %z"),  :details => o.description, :state => o.current_order_state.state}} 

		respond_with @result, :location => nil
	end


	### Vendor/Customer ###
	def get_menu_for_vendor
		unless params[:device_token].nil?
			@device = Device.where(:token => params[:device_token]).first
			@owner = @device.owner
		else
			@owner = Vendor.exists?(params[:object_id]) ? Vendor.find(params[:object_id]) : Restaurant.find(params[:object_id])
		end

		@menu = @owner.menu
		@categories = @menu.categories

		render status: :ok

		# respond_with @categories.map { 
  #     |cat| { :name => cat.name, :items => cat.items.map { 
  #       |item| { :item_details => item, :modifiers => item.modifiers.map {
  #        |modifier| {:modifier => modifier, :options => modifier.options} } } } } }, :location => nil

	end

	### Vendor ###
	# Register a device token with a vendor
	def register_device_token_for_vendor
		@owner = Vendor.where(:registration_code => params[:registration_code]).first
		@owner = Restaurant.where(:registration_code => params[:registration_code]).first if @owner.nil?

		if @owner.nil? 
			render :json => { :error => "incorrect_registration_code" } 
		else
			@device = Device.where(:token => params[:device_token]).first_or_create
			@device.update_owner @owner
			@device.save

			render :json => { :vendor_name => @device.owner.name, :vendor_id => @device.owner.id, :initial_state => @device.owner.initial_state, :is_open => @device.owner.open }
		
		end
	end

	### Vendor ###
	# Unregister a device token with a vendor
	def unregister_device
		@device = Device.where(:token => params[:device_token]).first
		@device.vendor = nil
		@device.restaurant = nil
		@device.save

		respond_with @device, :location => nil
	end

	### Vendor ###
	def update_order_state
		@order = Order.find(params[:order_id])
		render :json => { :error => "Order not found in table" } if @order.nil?

		@order_state = @order.update_state

		@order.notify_customer_of_completed_order if @order_state.state == 2

		render :json => @order_state
	end

	# Post request to log a user in.
	# If the user is successfully logged in, it sends back the users authentication token

	### Vendor & Customer ###
	def login
		@user = User.where(:email => params[:email]).first
		@response = Hash.new

		if @user
			if @user.valid_password?(params[:password])
				@response[:auth_token] =  @user.authentication_token
				@response[:name] = @user.name
				@response[:phone_number] = @user.number
				@response[:email] = @user.email

			else
				@response[:error] = "incorrect_password"
			end
		else
			@response[:error] = "incorrect_email"
		end
		respond_with(@response, :location => nil)
	end

	  ### Vendor ###
	def toggle_item_sold_out
		@item = Item.find(params[:item_id])
		if @item.nil?
			render :json => {:error => "Item not found"}
		else
			@item.update_attribute(:sold_out, !@item.sold_out)
			render :json => {:success => "success", :item_id => @item.id, :sold_out => @item.sold_out }
		end
	end

	  ### Vendor ###
	def toggle_store_open
		@device = Device.where(:token =>params[:device_token]).first
		@loc = @device.owner
		@loc.update_attribute(:open, !@loc.open)
		render :json => {:success => "success", :open => @loc.open, :location_id => @loc.id }
	end



	  ### Vendor ###
	def vendors_by_user_token
		@user = User.where(:authentication_token => params[:auth_token]).first
		if @user.is_super
			@vendors = Vendor.all
		else
			@vendors = Vendor.where(:roles => {:id => @user.role.id})
		end
		render :json => @vendors
	end

	### Customer ###
	def customer
		# Set your secret key: remember to change this to your live secret key in production
		# See your keys here https://dashboard.stripe.com/account
		Stripe.api_key = 'sk_test_xDJ5KS0I8VgJvHSQT1Iuxy56'
		# Get the credit card details submitted by the form
		@response = Hash.new
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
			#@response[:errors]=err[:type]
			#respond_with(@response,:location => nil)
		rescue Stripe::InvalidRequestError => e
		# Invalid parameters were supplied to Stripe's API
			#err  = body[:error]
			#puts "Status is: #{e.http_status}"
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

		respond_with(@customer, :location => nil)

	end

	# def create
 #    amount = 0
 #    if params[:order][:vendor_id].nil?
 #      owner = Restaurant.find(params[:order].delete(:restaurant_id), :include => {:menu => :items})
 #    else
 #      owner = Vendor.find(params[:order].delete(:vendor_id), :include => {:menu => :items})
 #    end
 #    unless owner.is_open?
 #      respond_with("#{owner.name} is currently not taking orders.", location: :nil)
 #    end
 #    user_id = params[:order].delete(:user_id)
 #    items = owner.menu.items
 #    items_price = Hash[items.map { |it| [it.id, (it.price).to_int]}]
 #    @order = Order.create(:user_id => user_id)
 #    params[:order].delete(:item).each { |id, qty|
 #      if qty.to_i != 0
 #        order_item = @order.order_items.create(:item_id => id.to_i, :quantity => qty.to_i)
 #        item = Item.find(id.to_i)
 #        cost = qty.to_i * items_price[id.to_i]
 #        # This assumes that if someone orders multiple of the item, then they want them
 #        # all modified exactly the same way.
 #        # Changing it when we allow multiple modifiers shouldn't be too difficult, we just need a while loop
 #        # for each item.
 #        item.modifiers.each do |mod|
 #          option_id = params["#{id}_#{mod.id}"]
 #          order_mod = order_item.order_modifiers.create(:modifier_id => mod.id)
 #          # If the modifier was a checkbox modifier
 #          # then we go through every selected option and add it.
 #          if option_id.is_a?(Array)
 #            option_id.each do |op_id|
 #              option = Option.find(op_id.to_i)
 #              order_mod.options << option
 #              if mod.is_size_dependent?
 #                selected_size = params["#{id}_#{item.modifiers.where(:mod_type => 0).first.id}"]
 #                m_price = option.size_prices.where(:size_id => selected_size).first.price
 #                cost += qty.to_i * m_price 
 #              else
 #                cost += qty.to_i * option.price unless option.price.nil?
 #              end
 #            end
 #          elsif option_id.to_i != 0
 #            option = Option.find(option_id.to_i)
 #            order_mod.options << option
 #            if mod.is_size_dependent?
 #              selected_size = params["#{id}_#{item.modifiers.where(:mod_type => 0).first.id}"]
 #              m_price = option.size_prices.where(:size_id => selected_size).first.price
 #              cost += qty.to_i * m_price 
 #            else
 #              cost += qty.to_i * option.price unless option.price.nil?
 #            end
 #          end
 #        end
 #        amount += cost
 #      end
 #    }
 #    @order.subtotal = amount
 #    @order.total = (owner.add_tax ? amount + amount*owner.tax : amount)
 #    owner.instance_of?(Vendor) ? @order.vendor = owner : @order.restaurant = owner
 #    if user_signed_in?
 #      @order.user = current_user
 #    else
 #      @order.user_info = UserInfo.create
 #    end
 #  end


	# EXPECTS
	# params[:order_id] = Order ID of order to be refunded
	def refund_order
		@order = Order.find(params[:order_id])

		if @order.refunded
			render :json => { :error => "Order has already been refunded" }
		else 
			charge = Stripe::Charge.retrieve(order.charge_id)
			refund = charge.refunds.create
			render :json => { :refunded => true, :refund_id => refund.id, :message => "Order refunded successfully" }
		end

	end

	### Vendor ###
	private
	# SHOULD BE PRIVATE BUT BREAKS IF I MAKE IT SO (unexpected keyword end when surrounding with private ... end)
	def restrict_access
		# api_key = ApiKey.find_by_access_token(params[:access_token])
		# head :unauthorized unless api_key

		authenticate_or_request_with_http_token do |token, options|
			ApiKey.exists?(:access_token => token)
		end
	end

	 def user_params
       params.require(:email).permit(:customer_id,:name,:number,:password)
     end
end
