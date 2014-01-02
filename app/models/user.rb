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
#  first_name             :string(255)
#  last_name              :string(255)
#

class User < ActiveRecord::Base
	STADIUM_MANAGER = 1
    CUSTOMER = 0
    VENDOR_MANAGER = 2
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 :recoverable, :rememberable, :trackable, :validatable

	has_one :role
	has_one :stadium, :through => :role

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me, :is_super, :first_name, :last_name
	# attr_accessible :title, :body

	validates_presence_of :role
	before_validation :create_role

	def create_role
		#defaults to customer
		self.role = Role.create(:role_type => 0) if self.role.nil?
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
		return role.is_super || role.role_type == STADIUM_MANAGER || role.role_type == VENDOR_MANAGER
	end

	def is_stadium_manager?
		return role.is_super || role.role_type == STADIUM_MANAGER
	end

	#Returns the names of all stadiums/vendors managed by this user in a 
	# ul li list
	def manages_list

	end


	def is_owner_of?(item) 
		# Stub Method
		return true if role.is_super
		return false
	end



end
