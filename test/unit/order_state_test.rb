# == Schema Information
#
# Table name: order_states
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class OrderStateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
