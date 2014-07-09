class CreateTransfers < ActiveRecord::Migration
  def up
    create_table :transfers do |t|
      t.string :transfer_id
      t.integer :location_id

      t.timestamps
    end

    add_column :orders, :transfer_id, :integer
  end

  def down
  	drop_table :transfers

  end
end
