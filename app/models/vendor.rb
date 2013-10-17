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
  attr_accessible :name
  belongs_to :stadium
  has_one :menu

  validates_presence_of :menu
end
