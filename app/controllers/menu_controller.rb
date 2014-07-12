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
		item = category.items.create(:name => params[:item][:name], :price => params[:item][:price])

		# Add modifiers
		unless params[:size_name_1].nil?
			size = item.modifiers.create(:mod_type=>"0", :name=> "size", :price=> nil)
			size.options.create(:name=> params[:size_name_1],:price=> params[:size_price_1])
			
			unless params[:size_name_2].nil?
				size.options.create(:name=> params[:size_name_2],:price=> params[:size_price_2])
			end	

			unless params[:size_name_3].nil?
				size.options.create(:name=> params[:size_name_3],:price=> params[:size_price_3])
			end
		end

		# ask AJ if meant to have all mod types to be 0
		unless params[:ss_title].nil? && params[:ss_name_1].nil?
			size = item.modifiers.create(:mod_type=>"0", :name=> params[:ss_title], :price=> nil)
			size.options.create(:name=> params[:ss_name_1],:price=> params[:ss_price_1])
			
			unless params[:ss_name_2].nil?
				size.options.create(:name=> params[:ss_name_2],:price=> params[:ss_price_2])
			end	

			unless params[:ss_name_3].nil?
				size.options.create(:name=> params[:ss_name_3],:price=> params[:ss_price_3])
			end
		end

		
		unless params[:ms_title].nil? && params[:ms_name_1].nil?
			size = item.modifiers.create(:mod_type=>"0", :name=> params[:ms_title], :price=> nil)
			size.options.create(:name=> params[:ms_name_1],:price=> params[:ms_price_1])
			
			unless params[:ms_name_2].nil?
				size.options.create(:name=> params[:ms_name_2],:price=> params[:ms_price_2])
			end	

			unless params[:ms_name_3].nil?
				size.options.create(:name=> params[:ms_name_3],:price=> params[:ms_price_3])
			end
		end

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

		# the single select mod, type = 1
		# the multiple select mod, type = 2
		# numeric mod, type = 4
		# custom mod, type = 5
	end

end
