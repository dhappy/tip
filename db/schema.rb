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

ActiveRecord::Schema.define(version: 20170216205547) do

  create_table "directories_references", id: false, force: :cascade do |t|
    t.integer "directory_id", null: false
    t.integer "reference_id", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.string   "code"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "destination"
  end

  create_table "entries_spaces", id: false, force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "space_id", null: false
  end

  create_table "references", force: :cascade do |t|
    t.string   "name"
    t.integer  "entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "references", ["entry_id"], name: "index_references_on_entry_id"

  create_table "spaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
