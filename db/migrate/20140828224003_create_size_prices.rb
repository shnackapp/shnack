class CreateSizePrices < ActiveRecord::Migration
  def up
    create_table :size_prices do |t|
      t.integer :size_id
      t.integer :option_id
      t.integer :price

      t.timestamps
    end

    add_column :modifiers, :is_size_dependent, :boolean, :default => false
  end


  def down
  	drop_table :size_prices
  	remove_column :modifiers, :is_size_dependent
  end
end
