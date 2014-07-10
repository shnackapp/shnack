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

		add_modifiers

		owner = menu.owner
		owner.instance_of?(Vendor) ?  redirect_to(stadium_vendor_path(owner.stadium, owner)) : redirect_to(owner) 
	end


	def add_category
		menu = Menu.find(params[:category][:menu_id])
		menu.categories.create(:name => params[:category][:name])

		owner = menu.owner
		owner.instance_of?(Vendor) ?  redirect_to(stadium_vendor_path(owner.stadium, owner)) : redirect_to(owner) 
	end

	# add this to a helper with item id, category id, and menu id
	def add_modifiers
		#byebug
		# the size mod, type = 3
		unless params[:size_name_1].nil?
			# @ necessary?
			items.modifiers.create(:modtype=>"3", :name=> "size", :price=> nil)
			items.modifiers.options.create(:name=> params[:size_name_1],:price=> params[:size_price_1])
		end

		unless params[:size_name_2].nil?
			items.modifiers.options.create(:name=> params[:size_name_2],:price=> params[:size_price_2])
		end

		unless params[:size_name_3].nil?
			items.modifiers.options.create(:name=> params[:size_name_2],:price=> params[:size_price_3])
		end

		# the single select mod, type = 1
		# the multiple select mod, type = 2
		# numeric mod, type = 4
		# custom mod, type = 5
	end

end
