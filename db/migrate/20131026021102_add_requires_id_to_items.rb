class AddRequiresIdToItems < ActiveRecord::Migration
  def change
  	add_column :items, :requires_id, :boolean
  end
end
