class AddWithdrawnToOrder < ActiveRecord::Migration
  def up
  	Order.all.each do |order| 
  		if order.shnack_cut.nil?
  			if order.owner.nil?
  				order.delete
  			else
  				order.update_attribute(:shnack_cut, order.subtotal * order.owner.shnack_percent/100 + order.owner.shnack_fee) 
  				order.update_attribute(:location_cut, order.subtotal - order.shnack_cut) if order.location_cut.nil? && !order.subtotal.nil?
ex
  			end
  		else 
	  		order.update_attribute(:location_cut, order.subtotal - order.shnack_cut) if order.location_cut.nil? && !order.subtotal.nil?
	  	end
  	end

  	add_column :orders, :withdrawn, :boolean, :default => false
  end
end
