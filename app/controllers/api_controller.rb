class ApiController < ApplicationController
	# http_basic_authenticate_with name: "admin", password: "secret"
	before_filter :restrict_access
	def index
		render json: User.all
	end

	
	# SHOULD BE PRIVATE BUT BREAKS IF I MAKE IT SO (unexpected keyword end when surrounding with private ... end)
	def restrict_access
		# api_key = ApiKey.find_by_access_token(params[:access_token])
		# head :unauthorized unless api_key

		authenticate_or_request_with_http_token do |token, options|
			ApiKey.exists?(access_token: token)
		end
	end


	

end
