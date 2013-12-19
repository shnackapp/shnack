# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  charge_id  :string(255)
#  amount     :integer
#  vendor_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  details    :string(255)
#  guest_id   :integer
#

class Order < ActiveRecord::Base
  attr_accessible :amount, :charge_id, :details 
  belongs_to :vendor
  belongs_to :user
  belongs_to :guest

  #details is in the form "item_id qty item_id qty ... "
end
