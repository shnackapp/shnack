class AddRegistrationCodeToRestaurants < ActiveRecord::Migration
  def change
  	add_column :locations, :registration_code, :string
  end
end
