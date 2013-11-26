# == Schema Information
#
# Table name: vendors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stadium_id :integer
#

class Vendor < ActiveRecord::Base
  attr_accessible :name, :stadium_id
  belongs_to :stadium
  has_one :menu
  belongs_to :role
  # belongs_to :user, :through => :role

  validates_presence_of :menu

end
