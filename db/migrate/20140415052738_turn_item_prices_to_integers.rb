class TurnItemPricesToIntegers < ActiveRecord::Migration
  def up
  	Item.all.each do |item|
  		item.price = item.price*100
  		item.save
  	end

  	change_column :items, :price, :integer
  end

  def down
  end
end
