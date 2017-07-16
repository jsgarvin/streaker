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

ActiveRecord::Schema.define(version: 20170715221223094) do

  create_table "activities", force: :cascade do |t|
    t.integer  "strava_id"
    t.datetime "started_at"
    t.string   "strava_type"
    t.decimal  "distance_in_meters",     precision: 8, scale: 1
    t.integer  "moving_time_in_seconds"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["started_at"], name: "index_activities_on_started_at"
    t.index ["strava_id"], name: "index_activities_on_strava_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "payload_digest"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "snapshots", force: :cascade do |t|
    t.datetime "shot_at"
    t.integer  "active_days_in_a_row"
    t.integer  "active_days_in_last_month"
    t.integer  "active_days_in_last_quarter"
    t.integer  "active_days_in_last_year"
    t.integer  "active_days_in_last_three_years"
    t.integer  "active_days_in_last_five_years"
    t.integer  "active_weeks_in_a_row"
    t.integer  "active_weeks_in_last_month"
    t.integer  "active_weeks_in_last_quarter"
    t.integer  "active_weeks_in_last_year"
    t.integer  "active_weeks_in_last_three_years"
    t.integer  "active_weeks_in_last_five_years"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["active_days_in_a_row"], name: "index_snapshots_on_active_days_in_a_row"
    t.index ["active_days_in_last_five_years"], name: "index_snapshots_on_active_days_in_last_five_years"
    t.index ["active_days_in_last_month"], name: "index_snapshots_on_active_days_in_last_month"
    t.index ["active_days_in_last_quarter"], name: "index_snapshots_on_active_days_in_last_quarter"
    t.index ["active_days_in_last_three_years"], name: "index_snapshots_on_active_days_in_last_three_years"
    t.index ["active_days_in_last_year"], name: "index_snapshots_on_active_days_in_last_year"
    t.index ["active_weeks_in_a_row"], name: "index_snapshots_on_active_weeks_in_a_row"
    t.index ["active_weeks_in_last_five_years"], name: "index_snapshots_on_active_weeks_in_last_five_years"
    t.index ["active_weeks_in_last_month"], name: "index_snapshots_on_active_weeks_in_last_month"
    t.index ["active_weeks_in_last_quarter"], name: "index_snapshots_on_active_weeks_in_last_quarter"
    t.index ["active_weeks_in_last_three_years"], name: "index_snapshots_on_active_weeks_in_last_three_years"
    t.index ["active_weeks_in_last_year"], name: "index_snapshots_on_active_weeks_in_last_year"
    t.index ["shot_at"], name: "index_snapshots_on_shot_at"
  end

end
