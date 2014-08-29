# == Schema Information
#
# Table name: modifiers
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  price             :integer
#  item_id           :integer
#  mod_type          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_size_dependent :boolean          default(FALSE)
#

class Modifier < ActiveRecord::Base
  attr_accessible :name, :price, :mod_type
  belongs_to :item
  has_many :order_modifiers 
  has_many :options

  TYPE_OF_MODIFIER = ['Variable Size','Single Select', 'Multiple Select', 'Numeric Input']
  # mod_type    Size = 0    Single Select = 1     Multiple Select = 2

  def type_string
  	TYPE_OF_MODIFIER[self.mod_type]
  end

end
