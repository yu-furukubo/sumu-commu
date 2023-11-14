# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_11_14_082218) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "boards", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "member_id"
    t.string "name", null: false
    t.text "body", null: false
    t.boolean "is_circular", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "circular_members", force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "communities", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "member_id", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "community_comments", force: :cascade do |t|
    t.integer "community_id", null: false
    t.integer "member_id", null: false
    t.text "comment", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "community_members", force: :cascade do |t|
    t.integer "community_id", null: false
    t.integer "member_id", null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "equipment", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "genre_id"
    t.string "name", null: false
    t.text "description"
    t.integer "stock", null: false
    t.string "storage_location", null: false
    t.string "return_location", null: false
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "event_members", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "member_id", null: false
    t.boolean "is_approved", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "member_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "started_at", null: false
    t.datetime "finished_at", null: false
    t.string "venue", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exchange_comments", force: :cascade do |t|
    t.integer "exchange_id", null: false
    t.integer "member_id", null: false
    t.text "comment", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "member_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "price", null: false
    t.datetime "deadline"
    t.boolean "is_finished", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "facilities", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "genre_id"
    t.string "name", null: false
    t.text "description"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "genres", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.string "name", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lost_item_comments", force: :cascade do |t|
    t.integer "lost_item_id", null: false
    t.integer "member_id", null: false
    t.text "comment", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lost_items", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "member_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "picked_up_location", null: false
    t.datetime "picked_up_at", null: false
    t.string "storage_location", null: false
    t.boolean "is_finished", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.string "name", null: false
    t.string "house_address", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "plans", force: :cascade do |t|
    t.integer "member_id", null: false
    t.string "subject", null: false
    t.date "start_date", null: false
    t.datetime "started_at", null: false
    t.date "finish_date", null: false
    t.datetime "finished_at", null: false
    t.string "venue", null: false
    t.text "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reads", force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "residence_id", null: false
    t.integer "member_id", null: false
    t.integer "equipment_id"
    t.integer "facility_id"
    t.date "start_date", null: false
    t.datetime "started_at", null: false
    t.date "finish_date", null: false
    t.datetime "finished_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "residences", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.integer "housing_type", default: 0, null: false
    t.string "name", null: false
    t.string "address", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "board_is_active", default: true, null: false
    t.boolean "community_is_active", default: true, null: false
    t.boolean "event_is_active", default: true, null: false
    t.boolean "exchange_is_active", default: true, null: false
    t.boolean "reservation_is_active", default: true, null: false
    t.boolean "lost_item_is_active", default: true, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
