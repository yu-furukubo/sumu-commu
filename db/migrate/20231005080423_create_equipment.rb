class CreateEquipment < ActiveRecord::Migration[6.1]
  def change
    create_table :equipment do |t|
      t.integer :residence_id,     null: false
      t.integer :genre_id
      t.string :name,              null: false
      t.text :description
      t.integer :stock,            null: false
      t.string :storage_location,  null: false
      t.string :return_location,   null: false
      t.text :note

      t.timestamps
    end
  end
end
