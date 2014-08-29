# == Schema Information
#
# Table name: size_prices
#
#  id          :integer          not null, primary key
#  size_id     :integer
#  modifier_id :integer
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SizePriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
