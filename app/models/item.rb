# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :decimal(8, 2)
#  menu_id    :integer          default(0), not null
#

class Item < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :price
  belongs_to :menu

  validates_presence_of :menu
end
