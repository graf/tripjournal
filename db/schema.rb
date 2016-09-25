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

ActiveRecord::Schema.define(version: 20160925085524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instagram_sources", force: :cascade do |t|
    t.string   "user_id"
    t.string   "last_media_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "kind",                               default: 0, null: false
    t.string   "title"
    t.string   "text"
    t.string   "image_url"
    t.string   "source_url"
    t.string   "source_id"
    t.string   "author"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.decimal  "lat",        precision: 9, scale: 6
    t.decimal  "lng",        precision: 9, scale: 6
    t.integer  "trip_id"
    t.index ["trip_id"], name: "index_notes_on_trip_id", using: :btree
  end

  create_table "photo_sources", force: :cascade do |t|
    t.string   "author",                          null: false
    t.string   "file",                            null: false
    t.float    "file_ratio", default: 1.0
    t.text     "file_exif",  default: "--- {}\n"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "points", force: :cascade do |t|
    t.decimal  "alt",        precision: 9, scale: 6, default: "0.0"
    t.decimal  "speed",      precision: 9, scale: 6, default: "0.0"
    t.decimal  "hdop",       precision: 9, scale: 6, default: "0.0"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.decimal  "lat",                                                null: false
    t.decimal  "lng",                                                null: false
    t.integer  "track_id"
    t.index ["created_at"], name: "index_points_on_created_at", using: :btree
  end

  create_table "tracks", force: :cascade do |t|
    t.text     "geojson_hq"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "geojson_lq"
    t.integer  "trip_id"
    t.index ["trip_id"], name: "index_tracks_on_trip_id", using: :btree
  end

  create_table "trips", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "checkpoints"
    t.datetime "start_date"
    t.datetime "finish_date"
    t.decimal  "length",                      null: false
    t.boolean  "published",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "notes", "trips"
  add_foreign_key "points", "tracks"
  add_foreign_key "tracks", "trips"
end
