# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(255)
#  number                 :string(255)
#  customer_id            :string(255)
#  name                   :string(255)
#  account_credit         :integer          default(0)
#  orders_count           :integer          default(0)
#

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

	has_one :role
	has_one :stadium, :through => :role
	has_many :events

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me, 
		:number, :name, :customer_id, :account_credit
	# attr_accessible :title, :body

	before_create :create_authentication_token, :set_account_credit
	after_create :create_role, :welcome

	has_many :orders
	validates :number, uniqueness: true

	def create_role
		#defaults to customer
		r = Role.create(:role_type => 0)
		r.user = self
		r.save
	end

	def set_account_credit
		self.account_credit = 500
	end

	def create_authentication_token
		begin
			self.authentication_token = SecureRandom.hex
		end while self.class.exists?(authentication_token: authentication_token)
	end

	# Needs to be phased out.
	def is_super
		role.is_super
	end

	def is_super?
		role.is_super
	end
	
	def role_type
		role.role_type
	end

	def stadium_id
		role.stadium.nil? ? 1 : role.stadium.id
	end

	def is_manager?
		role.role_type == 1 || role.is_super
	end

	def has_cards?
		!self.customer_id.nil? &&  Stripe::Customer.retrieve(self.customer_id).cards.count > 0
	end

	def cards
		self.customer_id.nil? ? [] : Stripe::Customer.retrieve(self.customer_id).cards 
	end

	def is_manager_of?(loc) 
		return true if role.is_super || role.locations.includes(loc)
	end

	def has_account_credit?
		self.account_credit > 0
	end

 	def welcome
    	welcome_message
  	end

  # ...

  	# The following functions send emails to users, designed to be called by a console script.
  	# Their names should be self explanatory
  	# @param email_sym: Corresponds to the name of the method in UserMailer that sends the email you'd like
  	def self.email_all(email_sym)
  		User.all.each { |u| UserMailer.announcement_email(u).deliver }
  	end

  	def self.email_customers_who_havent_ordered(email_sym)
		users =  User.all.select { |u| u.orders.paid.count == 0 }
		users.each { |u| UserMailer.announcement_email(u).deliver }
  	end

  	def self.email_customers_who_have_ordered_once(email_sym) 
  		users =  User.all.select { |u| u.orders.paid.count == 1 }
		users.each { |u| UserMailer.announcement_email(u).deliver }
  	end

  	def self.email_customers_who_have_ordered_more_than_once(email_sym) 
  		users =  User.all.select { |u| u.orders.paid.count > 1 }
		users.each { |u| UserMailer.announcement_email(u).deliver }
  	end

  	def self.email_user(email_sym, user)
  		UserMailer.announcement_email(user).deliver
  	end


private

  def welcome_message
    UserMailer.welcome_email(self).deliver
  end

end
