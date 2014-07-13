class CreateOrderModifiers < ActiveRecord::Migration
  def up
    create_table :order_modifiers do |t|
      t.integer :order_item_id
      t.integer :quantity
      t.integer :modifier_id

      t.timestamps
    end

    create_table :options_order_modifiers do |t|
    	t.belongs_to :order_modifier
    	t.belongs_to :option
    end

  end

  def down
    drop_table :order_modifiers
    drop_table :options_order_modifiers
  end
end
