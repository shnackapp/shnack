class AddStadiumIdToVendor < ActiveRecord::Migration
  def change
  	add_column :vendors, :stadium_id, :integer, :presence => true
  end
end
