class CreateExchangeComments < ActiveRecord::Migration[6.1]
  def change
    create_table :exchange_comments do |t|
      t.integer :exchange_id,   null: false
      t.integer :member_id,     null: false
      t.text :comment,          null: false

      t.timestamps
    end
  end
end
