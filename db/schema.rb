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

ActiveRecord::Schema.define(version: 20150129231224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string   "seat"
    t.integer  "customer_id"
    t.integer  "event_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "cost"
    t.string   "section"
  end

  add_index "tickets", ["customer_id"], name: "index_tickets_on_customer_id", using: :btree
  add_index "tickets", ["event_id"], name: "index_tickets_on_event_id", using: :btree

  add_foreign_key "tickets", "customers"
  add_foreign_key "tickets", "events"
end
