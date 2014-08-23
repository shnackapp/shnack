class AddRefundedToOrders < ActiveRecord::Migration
  def up
  	add_column :orders, :refunded, :boolean, :default => false
  end

  def down
  	remove_column :orders, :refunded
  end
end
