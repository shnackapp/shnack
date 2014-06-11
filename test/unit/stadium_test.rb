# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string(255)
#  registration_code :string(255)
#  open              :boolean
#  add_tax           :boolean          default(FALSE)
#  tax               :decimal(6, 6)
#  cash_only         :boolean          default(FALSE)
#  initial_state     :integer          default(0)
#

require 'test_helper'

class StadiumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
