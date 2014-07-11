class ShnackController < ApplicationController
	def logged_in
		redirect_to :action => "index"
	end

	def index
	end

	def contact
		@name = params[:cust_name]
		@email = params[:cust_email]
		@message = params[:cust_message]


		ContactUs.email_shnack(@name, @email, @message).deliver
		
		flash[:notice] = "Message sent. Thank you for the mail."

		redirect_to root_path


	end


	def manage_vendors
		# byebug
		if user_signed_in? && current_user.is_super
			@locations = Location.all
		elsif user_signed_in? && current_user.is_manager?
			@locations = current_user.role.locations
		else
			flash[:error] = "You are not authorized to view this page"
			redirect_to root_path
			# @vendors = Vendor.where(:role_id => current_user.role.id)
		end
	end
end
