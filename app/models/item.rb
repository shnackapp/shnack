# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  price       :integer
#  item_type   :string(255)
#  requires_id :boolean
#  nut_allergy :boolean
#  vegetarian  :boolean
#  category_id :integer
#  sold_out    :boolean          default(FALSE)
#

class Item < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :price, :item_type, :requires_id, :nut_allergy, :vegetarian
  belongs_to :category
  belongs_to :menu
  has_many :modifiers

  validates :name, presence: true
  validates :price, presence: true

  def self.integer_to_currency(amount, options = {})
    options[:unit] = "$" if options[:unit].nil?
    options[:separator] = "." if options[:separator].nil?

    return "Free" if amount == 0

    amount_str = amount.to_s
    cents = amount_str[-2,2]
    dollars = amount_str[0..-3]

    return "#{options[:unit]}#{dollars}#{options[:separator]}#{cents}"
  end

  def has_mod?
    self.modifiers.size > 0
  end


end
