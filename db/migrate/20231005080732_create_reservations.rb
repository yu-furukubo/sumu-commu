class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.integer :residence_id,       null: false
      t.integer :member_id,          null: false
      t.integer :equipment_id
      t.integer :facility_id
      t.datetime :started_at,        null: false
      t.datetime :finished_at,       null: false
      t.integer :using_status,       null: false, default: "0"

      t.timestamps
    end
  end
end