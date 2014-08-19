# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string(255)
#  registration_code :string(255)
#  open              :boolean
#  add_tax           :boolean          default(FALSE)
#  tax               :decimal(6, 6)
#  cash_only         :boolean          default(FALSE)
#  shnack_fee        :integer          default(50)
#  shnack_percent    :integer          default(5)
#  bank_account_id   :string(255)
#  hide_when_closed  :boolean          default(FALSE)
#  initial_state     :integer          default(0)
#

class Stadium < Location
  attr_accessible :name, :open
  has_many :vendors

  def is_open?
  	return self.open
  end

  def has_children
  	return self.vendors.count >= 1
  end

  def todays_closing_time
  	""
  end

end
