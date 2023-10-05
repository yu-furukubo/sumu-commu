class CreateCommunityComments < ActiveRecord::Migration[6.1]
  def change
    create_table :community_comments do |t|
      t.integer :community_id,     null: false
      t.integer :member_id,        null: false
      t.text :comment,             null: false

      t.timestamps
    end
  end
end
