class AddStadiumIdColumnToRoles < ActiveRecord::Migration
  def change
  	add_column :roles, :stadium_id, :integer
  end
end
