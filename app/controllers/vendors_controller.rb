class VendorsController < ApplicationController
	before_filter :setup_vendor, :except => [:index, :create, :new, :add_item, :add_category] 
	before_filter :check_manager
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

	def add_category
		vendor = Vendor.find(params[:category].delete(:vendor_id))
		vendor.menu.categories.create(:name => params[:category][:name])
		redirect_to stadium_vendor_path(@stadium, vendor)
	end


	def add_item
		category = Category.find(params[:item][:category_id])
		category.items.create(params[:item][:name], params[:item][:price], params[:item][:item_type], params[:item][:requires_id], params[:item][:nut_allergy], params[:item][:vegetarian])		redirect_to stadium_vendor_path(@stadium, vendor)
	end

	def setup_vendor
		@vendor = Vendor.find(params[:id])
	end

	def new_registration_code
		@vendor = Vendor.find(params[:id])

		@vendor.generate_registration_code
		@vendor.save

		redirect_to stadium_vendor_path(@vendor.stadium, @vendor)
	end


	def check_manager
		redirect_to root_path unless user_signed_in? && current_user.is_super
	end
end
