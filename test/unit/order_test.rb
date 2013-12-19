# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  charge_id  :string(255)
#  amount     :integer
#  vendor_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  details    :string(255)
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
