class CreateOrderModifiers < ActiveRecord::Migration
  def change
    create_table :order_modifiers do |t|
      t.integer :order_item_id
      t.integer :quantity

      t.timestamps
    end

    create_table :order_modifiers_options do |t|
    	t.belongs_to :order_modifier
    	t.belongs_to :option
    end

  end
end
