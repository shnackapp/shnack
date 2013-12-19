class AddEmailAndNameToOrders < ActiveRecord::Migration
  def change
  	# add_column :orders, :email, :string
  	# add_column :orders, :first_name, :string
  	# add_column :orders, :last_name, :string
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  end

  def down
	# remove_column :orders, :email
	# remove_column :orders, :first_name
	# remove_column :orders, :last_name

	remove_column :users, :first_name
	remove_column :users, :last_name
  end
end
