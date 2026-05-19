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

ActiveRecord::Schema[8.1].define(version: 2026_05_19_174955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "blood_donation_requests", force: :cascade do |t|
    t.bigint "blood_request_id", null: false
    t.datetime "created_at", null: false
    t.bigint "donor_profile_id", null: false
    t.text "message"
    t.datetime "responded_at"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["blood_request_id"], name: "index_blood_donation_requests_on_blood_request_id"
    t.index ["donor_profile_id"], name: "index_blood_donation_requests_on_donor_profile_id"
  end

  create_table "blood_requests", force: :cascade do |t|
    t.string "blood_group"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.string "hospital_name"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "patient_name"
    t.string "status"
    t.integer "units_required"
    t.datetime "updated_at", null: false
    t.string "urgency"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_blood_requests_on_user_id"
  end

  create_table "donor_profiles", force: :cascade do |t|
    t.boolean "available"
    t.string "blood_group"
    t.datetime "created_at", null: false
    t.datetime "last_active_at"
    t.datetime "last_donated_at"
    t.decimal "latitude"
    t.string "location"
    t.decimal "longitude"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "verified"
    t.index ["user_id"], name: "index_donor_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "is_admin", default: false, null: false
    t.string "jti", default: "", null: false
    t.string "name"
    t.string "phone_number"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "blood_donation_requests", "blood_requests"
  add_foreign_key "blood_donation_requests", "donor_profiles"
  add_foreign_key "blood_requests", "users"
  add_foreign_key "donor_profiles", "users"
end
