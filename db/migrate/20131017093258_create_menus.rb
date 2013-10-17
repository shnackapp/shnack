class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|

      t.timestamps
    end
    add_column :vendors, :menu_id, :integer
  end
end
