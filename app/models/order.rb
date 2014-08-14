# == Schema Information
#
# Table name: orders
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  charge_id       :string(255)
#  subtotal        :integer
#  vendor_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  details         :string(255)
#  paid            :boolean          default(FALSE)
#  restaurant_id   :integer
#  total           :integer
#  slug            :string(255)
#  slug_id         :string(255)
#  order_number    :integer
#  user_info_id    :integer
#  shnack_cut      :integer          default(0)
#  location_cut    :integer
#  withdrawn       :boolean          default(FALSE)
#  transfer_id     :integer
#  credit_was_used :boolean          default(FALSE)
#  credit_used     :integer          default(0)
#

class Order < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :subtotal, :total, :charge_id, :details, 
    :user_id, :slug_id, :order_number, :user_info, :withdrawn, :transfer_id, :paid

  friendly_id :slug_id, use: :slugged
  belongs_to :vendor
  belongs_to :restaurant
  belongs_to :user, :counter_cache => true
  belongs_to :user_info
  belongs_to :transfer
  has_many :order_states
  has_many :order_items


  scope :available, -> { where(:withdrawn => false).where('created_at < ?', 1.week.ago) }
  scope :paid, -> { where(:paid => true) }

  

  before_create :set_slug_id
  before_save :set_order_number

  def set_slug_id
    begin
      self.slug_id = SecureRandom.hex[0..6]
    end while Order.exists?(:slug_id => self.slug_id)
  end

  def set_order_number
    self.order_number = (self.owner.paid_orders.count + 1)%100 unless self.owner.nil? || !self.order_number.nil?
  end


  def to_param
    "#{slug_id}"
  end

  def notify_customer_of_completed_order
    client = Twilio::REST::Client.new Rails.configuration.twilio[:sid], Rails.configuration.twilio[:token] 

    customer = self.customer
    path = Rails.application.routes.url_helpers.order_path(self)

    unless customer.nil?
        client.account.messages.create({
        :from => Rails.configuration.twilio[:from],
        :to => customer.number,
          :body => "Your order ##{self.order_number} at #{self.owner.name} is ready to be picked up. shnackapp.com#{path}"    
        })
    end
  end


  #returns current order_state
  def current_order_state
  	o = self.order_states.descending.first
  	o.nil? ? self.order_states.create(:state => self.owner.initial_state) : o
  end

  #returns time in minutes
  def time_between_states(state_1, state_2)
    s1 = self.order_states.where(:state => state_1).first
    s2 = self.order_states.where(:state => state_2).first

    (s2.created_at - s1.created_at)/60
  end

  def update_state
  	o = current_order_state
  	o.state < 3 ? self.order_states.create(:state => o.state + 1) : o
  end

  def location_name
    self.vendor.nil? ? self.restaurant.name : self.vendor.name
  end

	def description
    order_items = self.order_items

		description = ""
		order_items.each do |order_item| 
      if Item.exists?(order_item.item_id)
        description = description + "#{order_item.quantity} #{Item.find(order_item.item_id).name} - #{order_item.item.category.name}"
        description = description + " - " if order_item.order_modifiers.size >= 1
        order_item.order_modifiers.each do |modifier|
          mod_description = ""
          modifier.options.map { |op| mod_description = mod_description + "#{op.name}, "}

          description = description + mod_description
        end
        
        description = description + "\n"
      end
    end

		description
	end

  def customer
    self.user.nil? ? self.user_info : self.user
  end

  def owner
    self.vendor.nil? ? self.restaurant : self.vendor
  end

  def self.integer_to_currency(amount, options = {})
    options[:unit] = "$" if options[:unit].nil?
    options[:separator] = "." if options[:separator].nil?

    amount_str = amount.to_s
    cents = amount_str.length < 2 ? "00" : amount_str[-2,2]
    dollars = amount_str.length < 3 ? "0" : amount_str[0..-3]

    return "#{options[:unit]}#{dollars}#{options[:separator]}#{cents}"
  end


  # NEEDS TO BE DEPRECATED
  def integer_to_currency(amount, options = {})
    options[:unit] = "$" if options[:unit].nil?
    options[:separator] = "." if options[:separator].nil?

    amount_str = amount.to_s
    cents = amount_str.length < 2 ? "00" : amount_str[-2,2]
    dollars = amount_str.length < 3 ? "0" : amount_str[0..-3]

    return "#{options[:unit]}#{dollars}#{options[:separator]}#{cents}"
  end




  #details is in the form "item_id qty item_id qty ... "
end
