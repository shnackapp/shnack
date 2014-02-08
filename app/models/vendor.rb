# == Schema Information
#
# Table name: vendors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stadium_id :integer
#  role_id    :integer
#

class Vendor < ActiveRecord::Base
  attr_accessible :name, :stadium_id
  has_one :menu
  has_many :devices
  belongs_to :role
  belongs_to :stadium

  # belongs_to :user, :through => :role

  validates_presence_of :menu

end
