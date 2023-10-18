class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|
      t.integer :residence_id,   null: false
      t.string :name,            null: false
      t.boolean :is_deleted,     null: false, default: "false"

      t.timestamps
    end
  end
end
