# == Schema Information
#
# Table name: size_prices
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  option_id  :integer
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class SizePriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
