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

class Location < ActiveRecord::Base
  attr_accessible :created_at, :id, :name, :updated_at, :type
  has_one :menu
  has_many :stadiums
  has_many :restaurants
end
