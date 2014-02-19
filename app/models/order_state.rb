# == Schema Information
#
# Table name: order_states
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderState < ActiveRecord::Base
  attr_accessible :state
  belongs_to :order

  scope :descending, order('created_at desc')

  def state_text
  	case self.state
	when 0
		return "Unread"
	when 1
		return "Being Prepared"
	when 2
		return "Ready"
	when 3
		return "Has been picked up"
	else
		return "Unrecognized State"
	end
  end


end
