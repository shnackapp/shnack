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
#

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

	has_one :role
	has_one :stadium, :through => :role

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me, :is_super
	# attr_accessible :title, :body

	validates_presence_of :role
	before_create :create_role, :create_authentication_token

	def create_role
		#defaults to customer
		r = Role.create(:role_type => 0)
		self.role = r
	end

	def create_authentication_token
		begin
			self.authentication_token = SecureRandom.hex
		end while self.class.exists?(authentication_token: authentication_token)
	end

	def is_super
		return role.is_super
	end
	
	def role_type
		return role.role_type
	end

	def stadium_id
		return role.stadium.nil? ? 1 : role.stadium.id
	end

	def is_manager?
		return role.role_type == 1
	end


	def is_owner_of?(item) 
		return true if role.is_super


	end



end
