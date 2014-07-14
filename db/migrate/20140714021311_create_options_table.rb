class CreateOptionsTable < ActiveRecord::Migration
  def up
  	create_table :options do |t|
  		t.string :name
  		t.integer :price
  		t.integer :modifier_id
  		     t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
  	end
  end

  def down
  	drop_table :options
  end
end
