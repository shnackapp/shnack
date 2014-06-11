class AddHideToRestaurants < ActiveRecord::Migration
  def change
  	add_column :locations, :hide_when_closed, :boolean, :default => false 
  end
end
