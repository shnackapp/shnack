# == Schema Information
#
# Table name: vendors
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stadium_id        :integer
#  role_id           :integer
#  registration_code :string(255)
#  add_tax           :boolean          default(FALSE)
#  tax               :decimal(6, 6)
#  cash_only         :boolean          default(FALSE)
#  shnack_fee        :integer          default(50)
#  shnack_percent    :integer          default(5)
#

class Vendor < ActiveRecord::Base
  attr_accessible :name, :stadium_id, :registration_code
  has_one :menu
  has_many :orders
  has_many :devices
  belongs_to :role
  belongs_to :stadium


  # belongs_to :user, :through => :role

  validates_presence_of :menu

  def is_open?
    return true
  end

  def open_orders
  	self.orders.select { |o| o.current_order_state.state < 3 && o.paid }
  end

  def past_orders
    self.orders.where(:paid => true).select { |o| o.current_order_state.state >= 3 }
  end

  def paid_orders
    self.orders.where(:paid => true)
  end

  def generate_registration_code
    begin
      self.registration_code = SecureRandom.hex[0..6]
    end while self.class.exists?(registration_code:registration_code) || Location.exists?(registration_code:registration_code)
  end

end
