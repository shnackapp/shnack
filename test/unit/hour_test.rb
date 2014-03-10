# == Schema Information
#
# Table name: hours
#
#  id           :integer          not null, primary key
#  opening_time :time
#  closing_time :time
#  day          :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class HourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
