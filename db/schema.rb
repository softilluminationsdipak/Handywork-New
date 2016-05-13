# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160513190741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "full_domain"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "label"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "deleted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "auth_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "authentication_token"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "auth_tokens", ["authentication_token"], name: "index_auth_tokens_on_authentication_token", unique: true, using: :btree
  add_index "auth_tokens", ["user_id"], name: "index_auth_tokens_on_user_id", using: :btree

  create_table "clinics", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "address_id"
    t.integer  "billing_address_id"
    t.string   "tax_uuid"
    t.string   "type_ii_npi_uuid"
    t.string   "main_provider_id"
    t.integer  "account_id"
    t.boolean  "same_as_service_location"
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.string   "phone1_ext"
    t.string   "phone1"
    t.string   "phone2_ext"
    t.string   "phone2"
    t.string   "phone3_ext"
    t.string   "phone3"
    t.string   "email1"
    t.string   "email2"
    t.string   "attention"
    t.text     "notes"
    t.string   "title"
    t.string   "fax1"
    t.string   "sex"
    t.string   "occupation"
    t.string   "middle_initial"
    t.datetime "deleted_at"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "plan_facilities", force: :cascade do |t|
    t.string   "name"
    t.integer  "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plan_facilities", ["plan_id"], name: "index_plan_facilities_on_plan_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "price",      default: 0
    t.string   "title"
    t.integer  "clinic",     default: 0
    t.integer  "doctor",     default: 0
    t.boolean  "primary",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "username"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
