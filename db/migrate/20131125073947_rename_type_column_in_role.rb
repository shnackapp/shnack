class RenameTypeColumnInRole < ActiveRecord::Migration
  def up
  	rename_column :roles, :type, :role_type
  end

  def down
  	rename_column :roles, :role_type, :type
  end
end
