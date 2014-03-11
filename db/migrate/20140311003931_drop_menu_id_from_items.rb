class DropMenuIdFromItems < ActiveRecord::Migration
  def up
  	remove_column :items, :menu_id
  end

  def down
  end
end
