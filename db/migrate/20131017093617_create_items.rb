class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.timestamps
    end
    add_column :items, :price, :decimal, :precision => 8, :scale => 2
	add_column :items, :menu_id, :integer, :null => false, :default => 0    
  end
end
