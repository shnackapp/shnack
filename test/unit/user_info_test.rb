# == Schema Information
#
# Table name: user_infos
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  number     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

require 'test_helper'

class UserInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
