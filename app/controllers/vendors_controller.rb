class VendorsController < ApplicationController
	before_filter :setup_vendor, :except => [:index, :create, :new, :add_item] 
	def index
		@vendors = Vendor.where(:stadium_id => @stadium.id)
	end
	def edit
		@vendor = Vendor.find(params[:id])
	end
	def update
		@vendor.update_attributes(params[:vendor])
		redirect_to stadium_vendor_path(@stadium, @vendor)
	end
	def new
		@vendor = @stadium.vendors.new
	end
	def create 
		vendor = @stadium.vendors.new(params[:vendor])
		vendor.build_menu
		vendor.save
		redirect_to stadium_vendors_path(@stadium)
	end
	def show
	end
	def destroy
		@vendor.destroy
		redirect_to stadium_vendors_path(@stadium)
	end


	def add_item
		vendor = Vendor.find(params[:item][:vendor_id])
		vendor.menu.add_item(params[:item][:name], params[:item][:price])
		redirect_to stadium_vendor_path(@stadium, vendor)
	end

	def setup_vendor
		@vendor = Vendor.find(params[:id])

	end
end
