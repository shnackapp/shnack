# == Schema Information
#
# Table name: size_prices
#
#  id          :integer          not null, primary key
#  size_id     :integer
#  modifier_id :integer
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SizePrice < ActiveRecord::Base
  attr_accessible :modifier_id, :price, :size_id
  
  belongs_to :modifier
  belongs_to :item
end
