class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.time :opening_time
      t.time :closing_time
      t.integer :day
      t.timestamps
    end
  end
end