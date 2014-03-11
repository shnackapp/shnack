# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  charge_id     :string(255)
#  subtotal      :integer
#  vendor_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  details       :string(255)
#  paid          :boolean          default(FALSE)
#  restaurant_id :integer
#  total         :integer
#

class Order < ActiveRecord::Base
  attr_accessible :subtotal, :total, :charge_id, :details
  belongs_to :vendor
  belongs_to :restaurant
  belongs_to :user
  has_many :order_states
  has_many :order_items


  #returns current order_state
  def current_order_state
  	o = self.order_states.descending.first
  	o.nil? ? self.order_states.create(:state => 0) : o
  end

  def update_state
  	o = current_order_state
  	o.state < 3 ? self.order_states.create(:state => o.state + 1) : o
  end

  def location_name
    self.vendor.nil? ? self.restaurant.name : self.vendor.name
  end

  def details_hash
    order_details = self.details.split
    order_details = order_details.map.with_index { |v, i|[order_details[i].to_i, order_details[i+1].to_i] if i.even? && order_details[i+1].to_i != 0 }
    order_details.reject! { |v| v.nil? }
    order_details = Hash[order_details]
    order_details
  end

	#converts a orders details hash:  Hash: {item_id => qty, item_id => qty ... }
	# to a hash:
	# Hash: { "item_name" => qty, "item_name" => qty }


	def description
		order_details = self.details_hash

		description = ""
		order_details.each { |id, qty| description = description + "#{qty} #{Item.find(id).name}\n"}

		description
	end

  def owner
    self.vendor.nil? ? self.restaurant : self.vendor
  end

  #details is in the form "item_id qty item_id qty ... "
end
