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
      if order_modifier.modifier.is_size_dependent?
        selected_size = self.order_modifiers.where(:modifier_id => self.item.size_modifier).first.options.first
        order_modifier.options.each do |option|
          total += option.size_prices.where(:size_id => selected_size.id).first.price
        end

      else
  		  order_modifier.options.each { |option| total+= option.price unless option.price.nil?}
      end
  	end

  	total

  end

end