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

class Restaurant < Location
  # attr_accessible :title, :body
  attr_accessible :registration_code, :open, :add_tax, :tax,
   :cash_only, :shnack_fee, :shnack_percent, :bank_account_id, :hide_when_closed, :initial_state

  has_many :hours
  has_many :orders
  has_many :devices
  has_one :menu


  def open_orders
  	self.orders.select { |o| o.current_order_state.state < 3 && o.paid }
  end

  def past_orders
    self.orders.select { |o| o.current_order_state.state >= 3 && o.paid }
  end
  
  def paid_orders
    self.orders.where(:paid => true)
  end

  def has_children
    false
  end

  def hide_when_closed?
    return self.hide_when_closed
  end

  def is_open?
    time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    h = self.hours.where(:day => time.wday).first
    return false if h.nil? || !self.open
    
    if time.hour < h.opening_hour || (time.hour == h.opening_hour && time.min < h.opening_min)
      # Check that it's not open in the previous day.
      day = time.wday == 0 ? 6 : time.wday-1
      h2 = self.hours.where(:day => day).first
      return false if h.nil?
      if h2.closing_hour < h.opening_hour || (h2.closing_hour == h.opening_hour && h2.closing_min < h.opening_min)
        return (time.hour < h2.closing_hour || (time.hour == h2.closing_hour && time.min < h2.closing_min))
      else
        return false
      end
    else
      #This else statement means the current time is past opening time
      # Check that it's before closing time

       # if closing time is before the opening time, then it's open past midnight and open right now
      return true if h.closing_hour < h.opening_hour || (h.closing_hour == h.opening_hour && h.closing_min < h.opening_min)
      # If current time is before closing time, it's open right now
      return time.hour < h.closing_hour || (time.hour == h.closing_hour && time.min < h.closing_min)

    end
  end

  def available_amount
    amount = 0
    self.orders.available.each { |order| amount = amount + order.location_cut unless order.location_cut.nil? }
    amount
  end

  def generate_registration_code
    begin
      self.registration_code = SecureRandom.hex[0..6]
    end while Vendor.exists?(registration_code:registration_code) || Location.exists?(registration_code:registration_code)
  end

end
