# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  vendor_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Device < ActiveRecord::Base
  attr_accessible :token
  belongs_to :vendor

end
