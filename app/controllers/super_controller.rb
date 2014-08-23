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

  		@users_with_orders = 0
      @users_with_mult_orders = 0
      User.all.each do |user|  
        @users_with_orders = @users_with_orders+1 if user.orders.paid.count > 0
        @users_with_mult_orders = @users_with_mult_orders + 1 if user.orders.paid.count > 1
      end
  		@percent_ordered = @users_with_orders.to_f / @users.count.to_f * 100
      @percent_repeat = @users_with_mult_orders.to_f / @users.count.to_f * 100

  		

      @amount_spent_in_credit = 0
  		@total = 0
  		@shnack_total = 0

  		@orders.each do |order|
        @amount_spent_in_credit = @amount_spent_in_credit + order.credit_used
  			@total = @total + order.total + order.credit_used
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