# == Schema Information
#
# Table name: user_infos
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  number     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserInfo < ActiveRecord::Base
	attr_accessible :email, :phone_number
	has_one :order
end
