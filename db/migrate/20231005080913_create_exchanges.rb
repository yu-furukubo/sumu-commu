class CreateExchanges < ActiveRecord::Migration[6.1]
  def change
    create_table :exchanges do |t|
      t.integer :residence_id,  null: false
      t.integer :member_id,     null: false
      t.string :name,           null: false
      t.text :description
      t.integer :price,         null: false
      t.datetime :deadline
      t.boolean :is_finished,   null: false, default: "false"

      t.timestamps
    end
  end
end
