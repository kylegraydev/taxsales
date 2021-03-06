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

ActiveRecord::Schema.define(version: 20160803042207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessments", force: true do |t|
    t.integer  "property_id"
    t.string   "use_type"
    t.string   "year_assessed"
    t.string   "total_value"
    t.string   "bdr"
    t.string   "ba"
    t.string   "bldg_sqft"
    t.string   "lot_acres"
    t.string   "year_built"
    t.string   "sale_amount"
    t.string   "recording_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_address"
    t.string   "zip"
  end

  create_table "properties", force: true do |t|
    t.string   "parcel_num"
    t.string   "name"
    t.string   "address"
    t.string   "legal_desc"
    t.string   "min_bid"
    t.string   "grid_num"
    t.string   "aerial_image_file_name"
    t.string   "aerial_image_content_type"
    t.integer  "aerial_image_file_size"
    t.datetime "aerial_image_updated_at"
    t.string   "defaulted_amount"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "zpid"
  end

  create_table "zillow_results", force: true do |t|
    t.integer  "property_id"
    t.string   "use_code"
    t.string   "bedrooms"
    t.string   "bathrooms"
    t.string   "finished_sq_ft"
    t.string   "lot_size_sq_ft"
    t.string   "year_built"
    t.string   "zillow_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zestimate"
  end

end
