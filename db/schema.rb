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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gl_accounts", force: true do |t|
    t.string   "account_number",                   null: false
    t.string   "name",                             null: false
    t.boolean  "active",                           null: false
    t.integer  "created_by",                       null: false
    t.integer  "updated_by",                       null: false
    t.datetime "created_at",     default: "now()", null: false
    t.datetime "updated_at",     default: "now()", null: false
    t.integer  "version",        default: 0,       null: false
  end

  add_index "gl_accounts", ["account_number"], name: "gl_accounts_account_number_key", unique: true, using: :btree
  add_index "gl_accounts", ["name"], name: "gl_accounts_name_key", unique: true, using: :btree

  create_table "gl_je_headers", force: true do |t|
    t.string   "je_number",                                                               null: false
    t.decimal  "debit_total",                  precision: 19, scale: 2,                   null: false
    t.decimal  "credit_total",                 precision: 19, scale: 2,                   null: false
    t.integer  "gl_period_id",                                                            null: false
    t.date     "accounting_date",                                                         null: false
    t.string   "description",     limit: 1024
    t.integer  "created_by",                                                              null: false
    t.integer  "updated_by",                                                              null: false
    t.datetime "created_at",                                            default: "now()", null: false
    t.datetime "updated_at",                                            default: "now()", null: false
    t.integer  "version",                                               default: 0,       null: false
  end

  add_index "gl_je_headers", ["je_number"], name: "gl_je_headers_je_number_key", unique: true, using: :btree

  create_table "gl_je_lines", force: true do |t|
    t.integer  "gl_je_header_id",                                              null: false
    t.integer  "debit_account_id",                                             null: false
    t.decimal  "debit_amount",      precision: 19, scale: 2,                   null: false
    t.integer  "credit_account_id",                                            null: false
    t.decimal  "credit_amount",     precision: 19, scale: 2,                   null: false
    t.datetime "updated_at",                                 default: "now()", null: false
    t.integer  "version",                                    default: 0,       null: false
  end

  create_table "gl_periods", force: true do |t|
    t.date     "first_day",                               null: false
    t.date     "last_day",                                null: false
    t.integer  "fiscal_year",                             null: false
    t.integer  "number_in_fiscal_year",                   null: false
    t.boolean  "open",                                    null: false
    t.integer  "created_by",                              null: false
    t.integer  "updated_by",                              null: false
    t.datetime "created_at",            default: "now()", null: false
    t.datetime "updated_at",            default: "now()", null: false
    t.integer  "version",               default: 0,       null: false
  end

  create_table "users", force: true do |t|
    t.string   "user_name",                    null: false
    t.string   "email",                        null: false
    t.integer  "created_by",                   null: false
    t.integer  "updated_by",                   null: false
    t.datetime "created_at", default: "now()", null: false
    t.datetime "updated_at", default: "now()", null: false
    t.integer  "version",    default: 0,       null: false
  end

  add_index "users", ["email"], name: "users_email_key", unique: true, using: :btree
  add_index "users", ["user_name"], name: "users_user_name_key", unique: true, using: :btree

end
