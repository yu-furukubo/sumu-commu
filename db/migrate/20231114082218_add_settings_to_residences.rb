class AddSettingsToResidences < ActiveRecord::Migration[6.1]
  def change
    add_column :residences, :board_is_active, :boolean, default: true, null: false
    add_column :residences, :community_is_active, :boolean, default: true, null: false
    add_column :residences, :event_is_active, :boolean, default: true, null: false
    add_column :residences, :exchange_is_active, :boolean, default: true, null: false
    add_column :residences, :reservation_is_active, :boolean, default: true, null: false
    add_column :residences, :lost_item_is_active, :boolean, default: true, null: false
  end
end
