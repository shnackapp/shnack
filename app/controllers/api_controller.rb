class ApiController < ApplicationController
	# http_basic_authenticate_with name: "admin", password: "secret"
	before_filter :restrict_access

	respond_to :json
	def index
		respond_with User.all
	end


	# HTTP Request for when the device turns on and sends in it's device token
	def receive_device_token
		@device = Device.where(:token =>params[:device_token])
		if @device
			render :json => @device
		else
			render :json => {:error => "unregistered_device", :token => params[:device_token]}
		end

	end


	def register_device_token
		@vendor = Vendor.find(params[:vendor_id])
		# unless Device.exists?(:token => params[:device_token])
		# 	@device = @vendor.devices.create(:token => params[:device_token])
		# else	
		# 	#There should only be one device with this token in the database
			
		# end
		@device = Device.where(:token => params[:device_token]).first_or_create 
		render :json => @device
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
