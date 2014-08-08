class ApplicationController < ActionController::Base
  include ApplicationHelper
  force_ssl unless: :is_demo?
  protect_from_forgery
  before_filter :setup



  def select_stadium

    @locations = Location.all
    @locations.reverse!
  	@stadiums = Stadium.all
  end

	def select_vendor
    @loc = Location.find(params[:object_id])
    if @loc.instance_of?(Restaurant)
      redirect_to new_order_path(:restaurant_id => @loc.id) 
    else
  		@stadium = Stadium.find(params[:object_id])
  		@vendors = Vendor.all
    end
	end

	def select_items
		@vendor = Vendor.find(params[:object_id])
		@stadium = @vendor.stadium
	end

  def howdy
    render layout: false
  end

  def styleguide
    render layout: false
  end

  private
    def is_demo?
     request.subdomain == "demo"
    end

    def generate_identifier
      now = Time.now.to_i
      Digest::MD5.hexdigest(
        (request.referrer || '') +
        rand(now).to_s +
        now.to_s +
        (request.user_agent || '')
      )
    end


    # Set up for analytics.
    def setup
      unless cookies[:user_identity]
        @identity = generate_identifier
        cookies[:user_identity] = {
          :value => @identity, :expires => 5.years.from_now
        }
      else
        @identity = cookies[:km_identity]
      end

      if current_user
        if not cookies[:aliased]
          cookies[:aliased] = {
            :value => true,
            :expires => 5.years.from_now
          }
        end
        @current_user_id = current_user.id
      else
        @current_user_id = nil
      end
      
      Event.create(:user_id => @current_user_id, :event_type => "#{params[:controller]}_#{params[:action]}", :identity => @identity)

    end

end
