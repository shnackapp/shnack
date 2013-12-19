class AddGuestIdToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :guest_id, :integer
  end
end
