class AddTypeToItems < ActiveRecord::Migration
  def change
  	    add_column :items, :item_type, :string
  end

  def down
  	remove_column :items, :item_type
  end
end
