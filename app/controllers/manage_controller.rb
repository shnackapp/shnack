class ManageController < ApplicationController
	before_filter :check_logged_in_and_manager

	#If user is not logged in, redirect to root
	def check_logged_in_and_manager
		redirect_to root_path unless user_signed_in? && current_user.is_manager?
	end


	def index
		@managed =  current_user.is_stadium_manager? ? Stadium.find(current_user.stadium_id) : current_user.role.vendors
	end
end
