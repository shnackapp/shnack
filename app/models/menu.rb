# == Schema Information
#
# Table name: menus
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vendor_id  :integer
#

class Menu < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :vendor_id
  belongs_to :vendor
  has_many :items

  def add_item(name, price)
  	items.create(:name => name, :price => price)
  end
end
