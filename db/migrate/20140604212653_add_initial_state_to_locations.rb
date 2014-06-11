class AddInitialStateToLocations < ActiveRecord::Migration
  def up
  	add_column :locations, :initial_state, :integer, :default => 0
  	add_column :vendors, :initial_state, :integer, :default => 0
  end

  def down
  	remove_column :locations, :initial_state
  end
end
