class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :charge_id
      t.integer :amount
      t.integer :vendor_id

      t.timestamps
    end
  end
end
