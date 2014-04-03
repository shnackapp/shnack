class AddRecipientIdToLocation < ActiveRecord::Migration
  def change
  	add_column :locations, :recipient_id, :string
  end
end
