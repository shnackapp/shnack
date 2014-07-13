class OrderModifier < ActiveRecord::Base
  attr_accessible :order_item_id, :quantity, :modifier_id
  has_and_belongs_to_many :options
  belongs_to :order_item
  belongs_to :modifier
end
