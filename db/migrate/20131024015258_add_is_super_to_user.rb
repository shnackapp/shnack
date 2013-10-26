class AddIsSuperToUser < ActiveRecord::Migration
  def change
  	add_column :users, :is_super, :boolean, :default => false
  end
end
