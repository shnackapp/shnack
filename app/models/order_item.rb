# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  quantity   :integer
#  order_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderItem < ActiveRecord::Base
  attr_accessible :item_id, :order_id, :quantity
  belongs_to :order
  belongs_to :item
  has_many :order_modifiers

  def has_mods?
    self.order_modifiers.size > 0
  end

  def price
  	total = Item.find(self.item_id).price

  	self.order_modifiers.each do |order_modifier|
  		order_modifier.options.each { |option| total+= option.price }
  	end

  	total

  end

end