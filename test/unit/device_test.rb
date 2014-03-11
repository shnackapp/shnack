# == Schema Information
#
# Table name: devices
#
#  id            :integer          not null, primary key
#  token         :string(255)
#  vendor_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  restaurant_id :integer
#

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
