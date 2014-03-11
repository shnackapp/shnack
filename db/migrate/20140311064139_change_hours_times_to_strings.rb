class ChangeHoursTimesToStrings < ActiveRecord::Migration
  def up
  	change_column :hours, :opening_time, :string
  	change_column :hours, :closing_time, :string
  end

  def down
  end
end
