# == Schema Information
#
# Table name: options
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  price       :integer
#  modifier_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Option < ActiveRecord::Base
  attr_accessible :name, :price
  belongs_to :modifier
  has_many :size_prices
  has_and_belongs_to_many :order_modifiers

  default_scope { order("price ASC") }
  
end
