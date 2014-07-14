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

require 'test_helper'

class OrderModifierTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
