class AddColumnToMenu < ActiveRecord::Migration
  def change
  	add_column :menus, :location_id, :integer
  end
end
