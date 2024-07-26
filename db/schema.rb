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

ActiveRecord::Schema[7.1].define(version: 2024_07_25_104649) do
  create_table "applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "app_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chats_count"
  end

  create_table "chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.integer "chat_id_in_application"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "messages_count"
    t.index ["application_id"], name: "index_chats_on_application_id"
    t.index ["chat_id_in_application", "application_id"], name: "index_chats_on_chat_id_in_application_and_application_id", unique: true
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.bigint "chat_id", null: false
    t.bigint "application_id", null: false
    t.integer "message_id_in_chat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_messages_on_application_id"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["message_id_in_chat", "chat_id", "application_id"], name: "idx_on_message_id_in_chat_chat_id_application_id_67714cd203", unique: true
  end

  add_foreign_key "chats", "applications", on_delete: :cascade
  add_foreign_key "messages", "applications", on_delete: :cascade
  add_foreign_key "messages", "chats", on_delete: :cascade
end
