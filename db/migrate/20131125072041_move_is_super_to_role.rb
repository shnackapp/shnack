class MoveIsSuperToRole < ActiveRecord::Migration
  def up
  	remove_column :users, :is_super
  	add_column :roles, :is_super, :boolean, :default => false
  	add_column :roles, :type, :integer, :default => 0
  end

  def down
  	add_column :users, :is_super, :boolean, :default => false
  	remove_column :roles, :is_super
  end
end
