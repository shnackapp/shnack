# == Schema Information
#
# Table name: transfers
#
#  id          :integer          not null, primary key
#  transfer_id :string(255)
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Transfer < ActiveRecord::Base
  attr_accessible :location_id, :transfer_id
  has_many :orders
end
