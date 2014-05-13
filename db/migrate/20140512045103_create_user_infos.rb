class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.string :email
      t.string :phone_number
      t.timestamps
    end
  end
end
