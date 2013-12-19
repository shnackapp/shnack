# == Schema Information
#
# Table name: guests
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class GuestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
