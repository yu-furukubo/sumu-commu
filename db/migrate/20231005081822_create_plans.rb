class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.integer :member_id,      null: false
      t.string :subject,         null: false
      t.date :start_date,        null: false
      t.datetime :started_at,    null: false
      t.date :finish_date,       null: false
      t.datetime :finished_at,   null: false
      t.string :venue,           null: false
      t.text :memo

      t.timestamps
    end
  end
end
