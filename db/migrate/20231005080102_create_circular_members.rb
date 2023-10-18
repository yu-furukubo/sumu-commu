class CreateCircularMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :circular_members do |t|
      t.integer :board_id,      null: false
      t.integer :member_id,     null: false

      t.timestamps
    end
  end
end
