class AddSlugIdAndOrderNumber < ActiveRecord::Migration
  def up
  	add_column :orders, :slug, :string 
  	add_index :orders, :slug, unique: true
  	add_column :orders, :slug_id, :string
  	add_column :orders, :order_number, :integer

  	Order.all.each do |order|
  		begin
      		order.slug_id = SecureRandom.hex[0..6]
    	end while Order.exists?(:slug_id => order.slug_id)
    	unless order.owner.nil?
    		order.order_number = (order.owner.orders.where("id < ?", order.id).where(:paid => true).count + 1)%100 
    		
	    	order.save
    	else
    		order.delete
    	end
  	end

  end

  def down
  end
end
