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
#  slug          :string(255)
#  slug_id       :string(255)
#  order_number  :integer
#

class Order < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :subtotal, :total, :charge_id, :details, :user_id, :slug_id, :order_number

  friendly_id :slug_id, use: :slugged
  belongs_to :vendor
  belongs_to :restaurant
  belongs_to :user
  has_many :order_states
  has_many :order_items

  before_create :set_slug_id
  before_save :set_order_number

  def set_slug_id
    begin
      self.slug_id = SecureRandom.hex[0..6]
    end while Order.exists?(:slug_id => self.slug_id)
  end

  def set_order_number
    self.order_number = (self.owner.paid_orders.count + 1)%100 unless self.owner.nil? || !self.order_number.nil?
  end

  def to_param
    "#{slug_id}"
  end


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
