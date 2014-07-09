class CreateLocationRolesAssociation < ActiveRecord::Migration
  def change
 	create_table :locations_roles, id: false do |t|
	  t.belongs_to :role
	  t.belongs_to :location
	end
  end
  
end

