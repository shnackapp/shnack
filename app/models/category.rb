# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  attr_accessible :menu_id, :name
  belongs_to :menu
  has_many :items

end
