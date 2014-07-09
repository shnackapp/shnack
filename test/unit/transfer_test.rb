# == Schema Information
#
# Table name: transfers
#
#  id          :integer          not null, primary key
#  transfer_id :string(255)
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class TransferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
