class MakeOrderTotalNotNilAgain < ActiveRecord::Migration
  def up
  	  	Order.all.each do |order|
  		order.total = order.subtotal if order.total.nil?
  		order.save
  	end
  end

  def down
  end
end
