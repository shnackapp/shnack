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

end
