class SuperController < ApplicationController

  before_filter :check_for_super

  def check_for_super 
	unless current_user.is_super?
		flash[:error] = "You are not authorized to view this page"
		redirect_to root_path
 	end

  end

  def index
    render layout: false
  end

  	def manage_as_super
  		@devices = Device.all
  		@apikeys = ApiKey.all
  		@orders = Order.paid.where('shnack_cut != ?', 0).all
  		@non_user_orders = Order.paid.where(:user_id => nil)
  		@users = User.all

  		@total = 0
  		@shnack_total = 0

  		@orders.each do |order|
  			@total = @total + order.total
  			@shnack_total = @shnack_total + order.shnack_cut
  		end

	end

	def delete_api_key
		key = ApiKey.find(params[:id])
		key.delete
		flash[:notice] = "Key deleted successfully"
		redirect_to :action => "manage_as_super" 
	end

	def delete_device
		device = Device.find(params[:id])
		device.delete
		flash[:notice] = "Device deleted successfully"
				redirect_to :action => "manage_as_super" 

	end

	def create_api_key
		ApiKey.create
		redirect_to :action => "manage_as_super" 
	end
end