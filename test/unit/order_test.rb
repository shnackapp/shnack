# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  charge_id       :string(255)
#  subtotal        :integer
#  vendor_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  details         :string(255)
#  paid            :boolean          default(FALSE)
#  restaurant_id   :integer
#  total           :integer
#  slug            :string(255)
#  slug_id         :string(255)
#  order_number    :integer
#  user_info_id    :integer
#  shnack_cut      :integer          default(0)
#  location_cut    :integer
#  withdrawn       :boolean          default(FALSE)
#  transfer_id     :integer
#  credit_was_used :boolean          default(FALSE)
#  credit_used     :integer          default(0)
#  refunded        :boolean          default(FALSE)
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
