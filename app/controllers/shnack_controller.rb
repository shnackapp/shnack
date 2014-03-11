class ShnackController < ApplicationController
	def logged_in
		redirect_to :action => "index"
	end

	def index
	end

	def manage_vendors
		if current_user.is_super
			@stadium = Stadium.all
			@vendors = Hash.new
			@stadium.each do |s|
				@vendors[s.name] = s.vendors
			end
		else
			@vendors = Vendor.where(:role_id => current_user.role.id)
		end
	end
end
