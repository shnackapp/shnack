class AddOpenToLocations < ActiveRecord::Migration
  def change
  	add_column :locations, :open, :boolean
  end
end
