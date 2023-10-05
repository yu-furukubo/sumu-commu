class CreateBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :boards do |t|
      t.integer :residence_id,  null: false
      t.string :name,           null: false
      t.text :body,             null: false
      t.boolean :is_cercular,   null: false, default: "false"

      t.timestamps
    end
  end
end
