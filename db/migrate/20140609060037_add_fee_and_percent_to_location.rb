class AddFeeAndPercentToLocation < ActiveRecord::Migration
  def up
  	add_column :locations, :shnack_fee, :integer, :default => 50
  	add_column :locations, :shnack_percent, :integer, :default => 5
  	add_column :vendors, :shnack_fee, :integer, :default => 50
  	add_column :vendors, :shnack_percent, :integer, :default => 5
  	add_column :orders, :shnack_cut, :integer, :default => 0
  	add_column :orders, :location_cut, :integer
  end
  def down
  	remove_column :locations, :shnack_fee
  	remove_column :locations, :shnack_percent
  	remove_column :orders, :shnack_cut
  	remove_column :orders, :location_cut
  end
end
