class CreateResidences < ActiveRecord::Migration[6.1]
  def change
    create_table :residences do |t|
      t.integer :admin_id,      null: false
      t.integer :housing_type,  null: false, default: "0"
      t.string :name,           null: false
      t.string :address,        null: false

      t.timestamps
    end
  end
end
