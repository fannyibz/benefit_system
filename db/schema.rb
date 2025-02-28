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

ActiveRecord::Schema[8.0].define(version: 2025_02_27_084428) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "benefits", force: :cascade do |t|
    t.string "name"
    t.integer "recurrence", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rules", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.jsonb "conditions", default: {}
    t.bigint "benefit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_rules_on_benefit_id"
  end

  create_table "user_benefits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "benefit_id", null: false
    t.bigint "rule_id", null: false
    t.integer "amount", null: false
    t.integer "status", default: 0
    t.datetime "granted_at"
    t.datetime "consumed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_to_grant", default: 0
    t.index ["benefit_id"], name: "index_user_benefits_on_benefit_id"
    t.index ["rule_id"], name: "index_user_benefits_on_rule_id"
    t.index ["user_id", "benefit_id", "created_at"], name: "index_user_benefits_on_user_id_and_benefit_id_and_created_at"
    t.index ["user_id"], name: "index_user_benefits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "start_date"
    t.string "location"
    t.string "contract_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "rules", "benefits"
  add_foreign_key "user_benefits", "benefits"
  add_foreign_key "user_benefits", "rules"
  add_foreign_key "user_benefits", "users"
end
