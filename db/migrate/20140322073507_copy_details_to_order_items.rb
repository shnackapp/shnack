class CopyDetailsToOrderItems < ActiveRecord::Migration
  def up
  	Order.all.each do |order|
  		order_details = order.details.split

  		order_details = order_details.map.with_index { |v, i|[order_details[i].to_i, order_details[i+1].to_i] if i.even? && order_details[i+1].to_i != 0 }
    	order_details.reject! { |v| v.nil? }
    	order_details = Hash[order_details]

    	order_details.each do |id, qty|
    		order.order_items.create(:item_id => id, :quantity => qty) unless qty == 0
    	end


  	end
  end

  def down
  end
end
