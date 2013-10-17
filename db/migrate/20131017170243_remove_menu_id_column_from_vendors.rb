class RemoveMenuIdColumnFromVendors < ActiveRecord::Migration
  def up
  	remove_column :vendors, :menu_id
  end

  def down
  	add_column :vendors, :menu_id, :integer
  end
end
