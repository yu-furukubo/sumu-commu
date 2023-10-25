class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.integer :residence_id,       null: false
      t.integer :member_id,          null: false
      t.integer :equipment_id
      t.integer :facility_id
      t.date :start_date,            null: false
      t.datetime :started_at,        null: false
      t.date :finish_date,           null: false
      t.datetime :finished_at,       null: false

      t.timestamps
    end
  end
end
