class AddNameToUserAndUserInfo < ActiveRecord::Migration
  def up
  	add_column :users, :name, :string
  	add_column :user_infos, :name, :string
  end
  def down
  	remove_column :users, :name
  	remove_column :user_infos, :name
  end
end
