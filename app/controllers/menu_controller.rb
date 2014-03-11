class MenuController < ApplicationController

	def delete_item
		item = Item.find(params[:item_id])
		owner = item.category.menu.owner
		item.delete

		owner.instance_of?(Vendor) ?  redirect_to(stadium_vendor_path(owner.stadium, owner)) : redirect_to(owner) 
	end

	def add_item
		menu = Menu.find(params[:item][:menu_id])
		category = Category.find(params[:item][:category_id])
		category.items.create(:name => params[:item][:name], :price => params[:item][:price])

		owner = menu.owner
		owner.instance_of?(Vendor) ?  redirect_to(stadium_vendor_path(owner.stadium, owner)) : redirect_to(owner) 
	end


	def add_category
		menu = Menu.find(params[:category][:menu_id])
		menu.categories.create(:name => params[:category][:name])

		owner = menu.owner
		owner.instance_of?(Vendor) ?  redirect_to(stadium_vendor_path(owner.stadium, owner)) : redirect_to(owner) 
	end

end
