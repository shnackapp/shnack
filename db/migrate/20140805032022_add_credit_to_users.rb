class AddCreditToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :account_credit, :integer, :default => 0
  	add_column :orders, :credit_was_used, :boolean, :default => false
  	add_column :orders, :credit_used, :integer, :default => 0
  end

  def down
  	remove_column :users, :account_credit
  	remove_column :orders, :credit_was_used
  	remove_column :orders, :credit_used
  end
end
