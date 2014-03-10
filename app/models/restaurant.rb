# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#

class Restaurant < Location
  # attr_accessible :title, :body
  has_many :hours
  has_many :orders
end
