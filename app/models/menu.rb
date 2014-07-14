# == Schema Information
#
# Table name: menus
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  vendor_id     :integer
#  restaurant_id :integer
#

class Menu < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :vendor_id, :location_id
  belongs_to :vendor
  belongs_to :restaurant
  has_many :categories
  has_many :items, through: :categories

  # validates :name, presence: true
  # validates :price, presence: true

  def add_item(name, price, item_type, requires_id, nut_allergy, vegetarian)
  	items.create(:name => name, :price => price, :item_type => item_type, :requires_id => requires_id, :nut_allergy => nut_allergy, :vegetarian => vegetarian)
  end

  def owner
  	self.vendor.nil? ? self.restaurant : self.vendor
  end

end
