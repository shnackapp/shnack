class AddSoldOutToItems < ActiveRecord::Migration
  def up
  	add_column :items, :sold_out, :boolean, :default => false
  end
  
  def down
  	remove_column :items, :sold_out
  end
end
