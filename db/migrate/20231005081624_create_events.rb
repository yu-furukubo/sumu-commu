class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.integer :residence_id,    null: false
      t.string :name,             null: false
      t.text :description,        null: false
      t.datetime :started_at,     null: false
      t.datetime :finished_at,    null: false
      t.string :venue,            null: false

      t.timestamps
    end
  end
end
