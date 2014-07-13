class OrderModifier < ActiveRecord::Base
  attr_accessible :order_item_id, :quantity
  has_and_belongs_to_many :options
  belongs_to :order_item
  
end
