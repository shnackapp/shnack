class ShnackController < ApplicationController
	def logged_in
		redirect_to :action => "index"
	end

	def index
	end

	def manage_vendors
		if current_user.is_super
			vendors = Vendor.group(:stadium_id)
			@vendors = Hash.new
			vendors.each do |v|
				tmp = Vendor.where(:stadium_id => v.stadium_id)
				@vendors[v.stadium.name] = tmp
			end
		else
			@vendors = Vendor.where(:role_id => current_user.role.id)
		end
	end
end
