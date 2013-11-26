class AddRoleIdToVendor < ActiveRecord::Migration
  def change
  	add_column :vendors, :role_id, :integer
  end
end
