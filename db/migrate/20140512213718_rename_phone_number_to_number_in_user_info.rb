class RenamePhoneNumberToNumberInUserInfo < ActiveRecord::Migration
  def up
  	rename_column :user_infos, :phone_number, :number
  end

  def down
  end
end
