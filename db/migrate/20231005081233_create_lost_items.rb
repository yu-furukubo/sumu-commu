class CreateLostItems < ActiveRecord::Migration[6.1]
  def change
    create_table :lost_items do |t|
      t.integer :residence_id,         null: false
      t.integer :member_id,            null: false
      t.string :name,                  null: false
      t.text :description
      t.string :picked_up_location,    null: false
      t.datetime :picked_up_at,        null: false
      t.string :storage_location,      null: false
      t.datetime :deadline
      t.boolean :is_finished,          null: false, default: "false"

      t.timestamps
    end
  end
end
