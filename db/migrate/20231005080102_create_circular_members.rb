class CreateCircularMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :circular_members do |t|
      t.integer :board_id,      null: false
      t.integer :member_id,     null: false
      t.boolean :is_checked,    null: false, default: "false"

      t.timestamps
    end
  end
end
