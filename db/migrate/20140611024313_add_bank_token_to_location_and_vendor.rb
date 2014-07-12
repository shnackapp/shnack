class AddBankTokenToLocationAndVendor < ActiveRecord::Migration
  def change
  	add_column :locations, :bank_account_id, :string
  	add_column :vendors, :bank_account_id, :string

  end
end
