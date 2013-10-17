class CreateEmptyMenuForAllVendors < ActiveRecord::Migration
  def up
  	add_column :menus, :vendor_id, :integer
  	Vendor.all.each do |v|
  		menu = Menu.create
  		v.menu = menu
  	end
  end

  def down
  end
end
