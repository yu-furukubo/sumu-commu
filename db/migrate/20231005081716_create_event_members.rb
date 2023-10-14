class CreateEventMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :event_members do |t|
      t.integer :event_id,    null: false
      t.integer :member_id,   null: false
      t.boolean :is_approved,    null: false, default: "false"

      t.timestamps
    end
  end
end
