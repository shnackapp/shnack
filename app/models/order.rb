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
  attr_accessible :subtotal, :total, :charge_id, :details, :user_id
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

	def description
    order_items = self.order_items

		description = ""
		order_items.each { |order_item| description = description + "#{order_item.quantity} #{Item.find(order_item.item_id).name}\n"}

		description
	end

  def owner
    self.vendor.nil? ? self.restaurant : self.vendor
  end

  def integer_to_currency(amount, options = {})
    options[:unit] = "$" if options[:unit].nil?
    options[:separator] = "." if options[:separator].nil?

    amount_str = amount.to_s
    cents = amount_str[-2,2]
    dollars = amount_str[0..-3]

    return "#{options[:unit]}#{dollars}#{options[:separator]}#{cents}"
  end


  #details is in the form "item_id qty item_id qty ... "
end
