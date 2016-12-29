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

ActiveRecord::Schema.define(version: 20161229063718) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cameras", force: :cascade do |t|
    t.string   "model"
    t.float    "resolution"
    t.integer  "manufacturer_id"
    t.integer  "sensor_type_id"
    t.integer  "mount_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["manufacturer_id"], name: "index_cameras_on_manufacturer_id", using: :btree
    t.index ["sensor_type_id"], name: "index_cameras_on_sensor_type_id", using: :btree
  end

  create_table "creators", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "url"
    t.integer  "creator_id"
    t.integer  "camera_id"
    t.integer  "lens_id"
    t.string   "aperture"
    t.string   "shutter_speed"
    t.integer  "iso"
    t.integer  "focal_length"
    t.jsonb    "exif"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "lenses", force: :cascade do |t|
    t.string   "model"
    t.float    "min_aperture"
    t.float    "max_aperture"
    t.integer  "min_focal_length"
    t.integer  "max_focal_length"
    t.integer  "manufacturer_id"
    t.integer  "sensor_type_id"
    t.integer  "mount_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["manufacturer_id"], name: "index_lenses_on_manufacturer_id", using: :btree
    t.index ["sensor_type_id"], name: "index_lenses_on_sensor_type_id", using: :btree
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensor_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cameras", "manufacturers"
  add_foreign_key "cameras", "sensor_types"
  add_foreign_key "lenses", "manufacturers"
  add_foreign_key "lenses", "sensor_types"
end
