class Option < ActiveRecord::Base
  attr_accessible :name, :price
  belongs_to :modifier

end
