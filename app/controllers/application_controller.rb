class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
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
		@stadium = Stadium.find(params[:object_id])
		@vendors = Vendor.all
	end

	def select_items
		@vendor = Vendor.find(params[:object_id])
		@stadium = @vendor.stadium
	end


end
