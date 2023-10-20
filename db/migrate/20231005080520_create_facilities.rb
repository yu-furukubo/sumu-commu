class CreateFacilities < ActiveRecord::Migration[6.1]
  def change
    create_table :facilities do |t|
      t.integer :residence_id,     null: false
      t.integer :genre_id
      t.string :name,              null: false
      t.text :description
      t.text :note

      t.timestamps
    end
  end
end
