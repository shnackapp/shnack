# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_super   :boolean          default(FALSE)
#  type       :integer          default(0)
#

# Type values:
# 0 = CUSTOMER
# 1 = MANAGER OF VENDOR

# If it's a manager, they must belong to a stadium

class Role < ActiveRecord::Base
  attr_accessible :type

  belongs_to :user
  has_many :vendors
  belongs_to :stadium

  #Check if this role owns a place
  def owns?(place) 


  end

end
