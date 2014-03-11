class RestaurantsController < ApplicationController
	def index
	  	@restaurants = Restaurant.all
	end
	def show
		@restaurant = Restaurant.find(params[:id])
	end
	def new
		@restaurant = Restaurant.new
	end
	def edit
		@restaurant = Restaurant.find(params[:id])
	end
	def update
		@restaurant = Restaurant.find(params[:id])
		@restaurant.update_attributes(params[:restaurant])
		redirect_to @restaurant
	end
	def create
		@restaurant = Restaurant.create(params[:restaurant])
		@menu = Menu.create
		@menu.restaurant = @restaurant
		@menu.save
		
		redirect_to @restaurant
	end
	def destroy
		Restaurant.find(params[:id]).destroy
		redirect_to :action => :index
	end

	def add_item
		restaurant = Restaurant.find(params[:item].delete(:restaurant_id))
		category = Category.where(:id => params[:item].delete(:category_id)).first
	category.items.create(:name => params[:item][:name], :price => params[:item][:price])

		redirect_to restaurant
	end

	def add_category
		restaurant = Restaurant.find(params[:item][:restaurant_id])
		restaurant.menu.categories.create(:name => params[:item][:name])
		redirect_to restaurant
	end

	def delete_item
		Item.find(params[:item_id]).delete
		redirect_to restaurant
	end
end
