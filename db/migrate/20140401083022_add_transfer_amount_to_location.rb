class AddTransferAmountToLocation < ActiveRecord::Migration
  def change
  	  	add_column :locations, :transfer_total, :integer
  end
end
