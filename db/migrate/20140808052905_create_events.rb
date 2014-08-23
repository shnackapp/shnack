class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :event_type
      t.string :identity

      t.timestamps
    end
  end
end
