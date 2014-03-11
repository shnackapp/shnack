class AddRestaurantIdToDevice < ActiveRecord::Migration
  def change
  	add_column :devices, :restaurant_id, :integer
  end
end
