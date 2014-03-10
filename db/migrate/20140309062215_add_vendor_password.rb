class AddVendorPassword < ActiveRecord::Migration
  def up
  	add_column :vendors, :registration_code, :string
  end

  def down
  end
end
