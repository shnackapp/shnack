class AddNumberToUserAndLocationIdToOrder < ActiveRecord::Migration
  def change
  	add_column :users, :number, :string
  	add_column :orders, :location_id, :integer
  end
end
