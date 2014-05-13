class ApplicationController < ActionController::Base
  include ApplicationHelper
  force_ssl unless request.subdomain == "demo"
  protect_from_forgery
  config.relative_url_root = ""
  before_filter :setup

  def setup
  	unless params[:stadium_id].nil?
  		@stadium = Stadium.find(params[:stadium_id])
  	end
  end

  def select_stadium
    @locations = Location.all
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


end
