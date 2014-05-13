class AddUserInfoToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :user_info_id, :integer
  end
end
