# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string(255)
#  registration_code :string(255)
#  open              :boolean
#  add_tax           :boolean          default(FALSE)
#  tax               :decimal(6, 6)
#

class Stadium < Location
  attr_accessible :name, :open
  has_many :vendors

  def is_open?
  	return self.open
  end

  def has_children
  	return self.vendors.count >= 1
  end

end
