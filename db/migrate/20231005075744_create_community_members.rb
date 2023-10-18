class CreateCommunityMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :community_members do |t|
      t.integer :community_id,   null: false
      t.integer :member_id,      null: false
      t.boolean :is_admin,       null: false, default: "false"

      t.timestamps
    end
  end
end
