# == Schema Information
#
# Table name: hours
#
#  id            :integer          not null, primary key
#  opening_time  :string(255)
#  closing_time  :string(255)
#  day           :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  restaurant_id :integer
#

require 'test_helper'

class HourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
