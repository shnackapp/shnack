# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  price       :integer
#  item_type   :string(255)
#  requires_id :boolean
#  nut_allergy :boolean
#  vegetarian  :boolean
#  category_id :integer
#  sold_out    :boolean          default(FALSE)
#  description :text
#

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
