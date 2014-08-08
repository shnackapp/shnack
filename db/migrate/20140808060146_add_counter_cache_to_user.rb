class AddCounterCacheToUser < ActiveRecord::Migration
  def change
  	add_column :users, :orders_count, :integer, :default => 0

  	User.all.each do |user|
  		User.update_counters user.id, :orders_count => user.orders.count
  	end
  end
end
