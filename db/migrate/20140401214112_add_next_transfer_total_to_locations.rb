class AddNextTransferTotalToLocations < ActiveRecord::Migration
  def change
  	add_column :locations, :next_transfer_total, :integer
  end
end
