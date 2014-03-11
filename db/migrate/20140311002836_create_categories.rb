class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :menu_id
      t.string :name

      t.timestamps
    end

    add_column :items, :category_id, :integer

    Menu.all.each do |menu|
    	category = menu.categories.create(:name => "Main Category")

    	menu.items.each do |item|
    		item.category = category
    		item.save
    	end
    end

  end
end
