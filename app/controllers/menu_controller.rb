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

		if (item = category.items.create(:name => params[:item][:name], :price => params[:item][:price], :description => params[:item][:description])).valid?

			# size mod
			unless params[:size_name_1].empty?
				size = item.modifiers.create(:mod_type=>"0", :name=> "size", :price=> nil)
				size.options.create(:name=> params[:size_name_1],:price=> params[:size_price_1])
				
				unless params[:size_name_2].empty?
					size.options.create(:name=> params[:size_name_2],:price=> params[:size_price_2])
				end	

				unless params[:size_name_3].empty?
					size.options.create(:name=> params[:size_name_3],:price=> params[:size_price_3])
				end
			end

			# single select mod
			unless params[:ss_title].empty? && params[:ss_name_1].empty?
				size = item.modifiers.create(:mod_type=>"1", :name=> params[:ss_title], :price=> nil)
				size.options.create(:name=> params[:ss_name_1],:price=> params[:ss_price_1])
				
				unless params[:ss_name_2].empty?
					size.options.create(:name=> params[:ss_name_2],:price=> params[:ss_price_2])
				end	

				unless params[:ss_name_3].empty?
					size.options.create(:name=> params[:ss_name_3],:price=> params[:ss_price_3])
				end

				unless params[:ss_name_4].empty?
					size.options.create(:name=> params[:ss_name_4],:price=> params[:ss_price_4])
				end

				unless params[:ss_name_5].empty?
					size.options.create(:name=> params[:ss_name_5],:price=> params[:ss_price_5])
				end
			end
			
			# mutli select mod
			unless params[:ms_title].empty? && params[:ms_name_1].empty?
				size = item.modifiers.create(:mod_type=>"2", :name=> params[:ms_title], :price=> nil)
				size.options.create(:name=> params[:ms_name_1],:price=> params[:ms_price_1])
				
				unless params[:ms_name_2].empty?
					size.options.create(:name=> params[:ms_name_2],:price=> params[:ms_price_2])
				end	

				unless params[:ms_name_3].empty?
					size.options.create(:name=> params[:ms_name_3],:price=> params[:ms_price_3])
				end
			end

			owner = menu.owner
			owner.instance_of?(Vendor) ?  redirect_to(stadium_vendor_path(owner.stadium, owner)) : redirect_to(owner)
		else 
			flash[:error] = "Item Name or Price Cannot Be Blank"
			owner = menu.owner
			owner.instance_of?(Vendor) ?  redirect_to(stadium_vendor_path(owner.stadium, owner)) : redirect_to(owner)
		end
	end


	def edit_item
		@item = Item.find(params[:item_id])

	end

	def update_item
		@item = Item.find(params[:item_id])
		params[:item][:description] = nil if params[:item][:description].empty?

		@item.update_attributes(params[:item])
		redirect_to @item.category.menu.owner

	end

	def new_modifier
		@item = Item.find(params[:item_id])
		@modifier = @item.modifiers.new
	end

	def add_modifier
		@item = Item.find(params[:item_id])

		#Validity checks

		# if modifier has no name, redirect to form with flash mesage
		if params[:mod_type].nil?
			flash[:error] = "Please select a modifier type"
			redirect_to :action => "new_modifier", :item_id => @item.id
			return
		end

		if (params[:modifier][:name].nil? || params[:modifier][:name].empty?  && params[:mod_type] != "0")
			flash[:error] = "Please enter a name"
			redirect_to :action => "new_modifier", :item_id => @item.id
			return
		end

		# if trying to create a second size modifier, redirect to form with flash message
		if params[:mod_type] == "0" && @item.has_size?
			flash[:error] = "This item already has a size modifier."
			redirect_to :action => "new_modifier", :item_id => @item.id
			return
		end


		mod = @item.modifiers.create(:mod_type => params[:mod_type], :name => params[:modifier][:name], :is_size_dependent => params[:modifier][:is_size_dependent])
		count = 0

		size = @item.modifiers.where(:mod_type => 0).first
		while !params["option_name_#{count}".to_sym].nil? && !params["option_name_#{count}".to_sym].empty? do
			if mod.is_size_dependent
				
				option = mod.options.create(:name => params["option_name_#{count}".to_sym])
				size.options.each_with_index do |size_option, index|
					option.size_prices.create(:size_id => size_option.id, :price => params["option_price_#{count}_#{index}"])
				end	
			else
				mod.options.create(:name => params["option_name_#{count}".to_sym], :price => params["option_price_#{count}".to_sym] )
				
			end
			count+= 1
		end
		

		redirect_to :action => "edit_item", :item_id => @item.id

	end

	# Still needs implementing, currently stubbed out
	def edit_modifier

	end

	def update_modifier

	end

	def delete_modifier
		@mod = Modifier.find(params[:mod_id])
		@item = @mod.item
		@mod.delete
		redirect_to :action => "edit_item", :item_id => @item.id
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
