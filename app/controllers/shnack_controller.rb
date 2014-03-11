class ShnackController < ApplicationController
	def logged_in
		redirect_to :action => "index"
	end

	def index
	end

	def manage_vendors
		if user_signed_in? && current_user.is_super
			@locations = Location.all


			# @stadium = Stadium.all
			# @vendors = Hash.new
			# @stadium.each do |s|
			# 	@vendors[s.name] = s.vendors
			# end
		else
			redirect_to root_path
			# @vendors = Vendor.where(:role_id => current_user.role.id)
		end
	end
end
