class MoveLocationIdToOrderId < ActiveRecord::Migration
  def up
  	rename_column :orders, :location_id, :restaurant_id
  end

  def down
  end
end
