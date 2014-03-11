class AddRestaurantIdToHours < ActiveRecord::Migration
  def change
  	add_column :hours, :restaurant_id, :integer
  end
end
