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

ActiveRecord::Schema.define(version: 2021_07_11_113016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "daily_statistics", force: :cascade do |t|
    t.bigint "discord_server_id", null: false
    t.integer "tracks_length", default: 0, null: false
    t.integer "tracks_amount", default: 0, null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discord_server_id", "date"], name: "index_daily_statistics_on_discord_server_id_and_date", unique: true
  end

  create_table "discord_servers", force: :cascade do |t|
    t.bigint "external_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_discord_servers_on_external_id", unique: true
  end

  create_table "discord_users", force: :cascade do |t|
    t.bigint "external_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_discord_users_on_external_id", unique: true
  end

  create_table "donations", force: :cascade do |t|
    t.integer "size", default: 0, null: false
    t.datetime "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "discord_server_id"
    t.bigint "discord_user_id"
    t.index ["discord_server_id"], name: "index_donations_on_discord_server_id"
    t.index ["discord_user_id"], name: "index_donations_on_discord_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "discord_server_id", null: false
    t.bigint "dj_role"
    t.string "language", limit: 2, default: "ru", null: false
    t.boolean "autopause", default: true, null: false
    t.integer "volume", default: 100, null: false
    t.string "prefix"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discord_server_id"], name: "index_settings_on_discord_server_id", unique: true
  end

  create_table "statistics", force: :cascade do |t|
    t.bigint "discord_server_id", null: false
    t.integer "tracks_length", default: 0, null: false
    t.integer "tracks_amount", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discord_server_id"], name: "index_statistics_on_discord_server_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vkdonate_donations", force: :cascade do |t|
    t.bigint "donation_id", null: false
    t.text "message"
    t.bigint "vk_user_external_id", null: false
    t.bigint "external_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donation_id"], name: "index_vkdonate_donations_on_donation_id", unique: true
    t.index ["external_id"], name: "index_vkdonate_donations_on_external_id", unique: true
  end

  create_table "vkponchik_donations", force: :cascade do |t|
    t.bigint "donation_id", null: false
    t.text "message"
    t.bigint "vk_user_external_id", null: false
    t.bigint "external_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donation_id"], name: "index_vkponchik_donations_on_donation_id", unique: true
    t.index ["external_id"], name: "index_vkponchik_donations_on_external_id", unique: true
  end

end
