class CreateCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :communities do |t|
      t.integer :residence_id,    null: false
      t.string :name,             null: false
      t.string :description

      t.timestamps
    end
  end
end
