class CreateModifiers < ActiveRecord::Migration
  def up
  	create_table :modifiers do |t|
      t.string :name
      t.integer :price
      t.integer :item_id
      t.integer :mod_type
      t.timestamps
    end
  end


  def down
	drop_table :modifiers
  end
end
