class AddNutAllergyToItems < ActiveRecord::Migration
  def change
  	add_column :items, :nut_allergy, :boolean
  end
end
