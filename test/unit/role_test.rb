# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_super   :boolean          default(FALSE)
#  role_type  :integer          default(0)
#  user_id    :integer
#  stadium_id :integer
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
