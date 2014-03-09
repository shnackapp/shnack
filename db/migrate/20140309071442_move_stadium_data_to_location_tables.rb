class MoveStadiumDataToLocationTables < ActiveRecord::Migration
  def up
  end

  def change
  	Stadium.find_each do |stadium|
  		Location.create(
  			:id => stadium.id,
  			:name => stadium.name,
  			:created_at => stadium.created_at,
  			:updated_at => stadium.updated_at
  			)
  	end
  end

  def down
  end
end
