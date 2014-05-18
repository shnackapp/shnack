class AddCashPayment < ActiveRecord::Migration
  def up
  	add_column :locations, :cash_only, :boolean, :default => false
  	add_column :vendors, :cash_only, :boolean, :default => false
  end

  def down
  	remove_column :locations, :cash_only
  	remove_column :vendors, :cash_only
  end
end
