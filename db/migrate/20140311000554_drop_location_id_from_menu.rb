class DropLocationIdFromMenu < ActiveRecord::Migration
  def up
  	remove_column :menus, :location_id
  	add_column :menus, :restaurant_id, :integer
  end

  def down
  	add_column :menus, :location_id, :integer
  end
end
