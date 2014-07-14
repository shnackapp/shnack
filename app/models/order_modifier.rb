# == Schema Information
#
# Table name: order_modifiers
#
#  id            :integer          not null, primary key
#  order_item_id :integer
#  quantity      :integer
#  modifier_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class OrderModifier < ActiveRecord::Base
  attr_accessible :order_item_id, :quantity, :modifier_id
  has_and_belongs_to_many :options
  belongs_to :order_item
  belongs_to :modifier
end
