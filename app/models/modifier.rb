# == Schema Information
#
# Table name: modifiers
#
#  id         :integer          not null, primary key
#  type       :integer
#  price      :integer
#  name       :string(255)
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Modifier < ActiveRecord::Base
  attr_accessible :name, :price, :mod_type
  belongs_to :item
  has_many :options

  TYPE_OF_MODIFIER = ['Variable Size','Single Select', 'Multiple Select', 'Numeric Input']
  # mod_type    Size = 0    Single Select = 1     Multiple Select = 2


end
