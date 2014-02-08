class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :token
      t.integer :vendor_id

      t.timestamps
    end
  end
end
