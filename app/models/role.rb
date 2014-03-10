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

# Type values:
# 0 = CUSTOMER
# 1 = MANAGER OR VENDOR
# 2 = STADIUM OR VENDOR

# If it's a manager, they must belong to a stadium

class Role < ActiveRecord::Base
  attr_accessible :role_type

  belongs_to :user
  has_many :vendors
  belongs_to :stadium

  #Check if this role owns a place
  def owns?(place) 
  	# STUB METHOD
  	return true
  end

end
