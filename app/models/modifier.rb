class Modifier < ActiveRecord::Base
  attr_accessible :name, :price, :type
  belongs_to :item
  has_many :options

  TYPE_OF_MODIFIER = ['Variable Size','Single Select', 'Multiple Select', 'Numeric Input']



end
