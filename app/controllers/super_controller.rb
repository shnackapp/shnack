class SuperController < ApplicationController

  before_filter :check_for_super

  def check_for_super 
	unless user_signed_in? && current_user.is_super?
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
  		@orders_credit = Order.paid.where(:credit_was_used => true)
  		@users = User.all

  		@users_with_orders = User.where('orders_count > 0')
  		@users_with_mult_orders = User.where('orders_count > 1')
  		@percent_ordered = @users_with_orders.count.to_f / @users.count.to_f * 100
      @percent_repeat = @users_with_mult_orders.count.to_f / @users.count.to_f * 100

  		@amount_spent_in_credit = 0
  		@orders_credit.each { |order| @amount_spent_in_credit += order.credit_used }

  		@total = 0
  		@shnack_total = 0

  		@orders.each do |order|
  			@total = @total + order.total
  			@shnack_total = @shnack_total + order.shnack_cut
  		end

  		@user_sign_up_rate = Event.where(:event_type => "devise/registrations_create").count.to_f/Event.where(:event_type => "devise/registrations_new").count.to_f * 100

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