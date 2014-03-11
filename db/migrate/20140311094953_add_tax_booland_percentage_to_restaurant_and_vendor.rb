class AddTaxBoolandPercentageToRestaurantAndVendor < ActiveRecord::Migration
  def change
  	add_column :locations, :add_tax, :boolean, :default => false
  	add_column :locations, :tax, :decimal, :precision =>6, :scale => 6

  	add_column :vendors, :add_tax, :boolean, :default => false
  	add_column :vendors, :tax, :decimal, :precision =>6, :scale => 6

  	rename_column :orders, :amount, :subtotal
  	add_column :orders, :total, :integer

  	Order.all.each do |order|
  		order.total = order.subtotal
  	end
  end
end
