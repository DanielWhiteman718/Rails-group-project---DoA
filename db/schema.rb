# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_23_101504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "theme_id", null: false
    t.string "code", null: false
    t.bigint "uni_module_id", null: false
    t.string "name", null: false
    t.boolean "archived", default: false, null: false
    t.text "notes"
    t.boolean "in_drive", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name_abrv"
    t.bigint "user_id"
    t.index ["theme_id", "code", "uni_module_id"], name: "index_activities_on_theme_id_and_code_and_uni_module_id", unique: true
    t.index ["theme_id"], name: "index_activities_on_theme_id"
    t.index ["uni_module_id"], name: "index_activities_on_uni_module_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_assesses", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.integer "num_assess"
    t.float "assess_weight"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "pre_assess_type_id"
    t.bigint "during_assess_type_id"
    t.bigint "post_assess_type_id"
    t.bigint "post_lab_type_id"
    t.index ["activity_id"], name: "index_activity_assesses_on_activity_id"
  end

  create_table "activity_gta", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.float "staff_ratio"
    t.integer "marking_time"
    t.text "job_desc"
    t.text "criteria"
    t.text "jobshop_desc"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_gta_on_activity_id"
  end

  create_table "activity_objectives", force: :cascade do |t|
    t.bigint "objective_id"
    t.string "short_desc"
    t.string "long_desc"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "programme_id"
    t.index ["objective_id"], name: "index_activity_objectives_on_objective_id"
    t.index ["programme_id"], name: "index_activity_objectives_on_programme_id"
  end

  create_table "activity_programmes", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "programme_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_programmes_on_activity_id"
    t.index ["programme_id"], name: "index_activity_programmes_on_programme_id"
  end

  create_table "activity_teachings", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "user_id"
    t.string "mole_pub_link"
    t.string "g_drive_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "resit_priority_id"
    t.index ["activity_id"], name: "index_activity_teachings_on_activity_id"
    t.index ["user_id"], name: "index_activity_teachings_on_user_id"
  end

  create_table "activity_teches", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "tech_lead_id"
    t.bigint "tech_ustudy_id"
    t.date "last_risk_assess"
    t.date "next_risk_assess"
    t.text "equip_needed"
    t.float "cost_per_student"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_teches_on_activity_id"
    t.index ["tech_lead_id"], name: "index_activity_teches_on_tech_lead_id"
    t.index ["tech_ustudy_id"], name: "index_activity_teches_on_tech_ustudy_id"
  end

  create_table "activity_timetables", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.boolean "same_as_prev_year", default: false, null: false
    t.boolean "checked_on_timetable", default: false, null: false
    t.integer "min_week_num"
    t.integer "max_week_num"
    t.integer "duration"
    t.integer "setup_time"
    t.integer "takedown_time"
    t.integer "series_setup_time"
    t.integer "kit_prep_time"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "pref_room_id"
    t.integer "capacity"
    t.index ["activity_id"], name: "index_activity_timetables_on_activity_id"
    t.index ["pref_room_id"], name: "index_activity_timetables_on_pref_room_id"
  end

  create_table "activity_wholes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "columns", force: :cascade do |t|
    t.string "table"
    t.string "db_name"
    t.string "display_name"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "dropdowns", force: :cascade do |t|
    t.string "drop_down"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "display_name"
    t.index ["drop_down"], name: "index_dropdowns_on_drop_down"
    t.index ["value"], name: "index_dropdowns_on_value"
  end

  create_table "edit_requests", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "initiator_id"
    t.bigint "target_id"
    t.string "title"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "column_id"
    t.integer "bulk_id"
    t.integer "status"
    t.string "new_val"
    t.index ["activity_id"], name: "index_edit_requests_on_activity_id"
    t.index ["column_id"], name: "index_edit_requests_on_column_id"
    t.index ["initiator_id"], name: "index_edit_requests_on_initiator_id"
    t.index ["target_id"], name: "index_edit_requests_on_target_id"
  end

  create_table "gta_invites", force: :cascade do |t|
    t.bigint "activity_gta_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_gta_id"], name: "index_gta_invites_on_activity_gta_id"
    t.index ["user_id"], name: "index_gta_invites_on_user_id"
  end

  create_table "objective_linkers", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "activity_objective_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_objective_linkers_on_activity_id"
    t.index ["activity_objective_id"], name: "index_objective_linkers_on_activity_objective_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "programmes", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "initiator_id"
    t.bigint "target_id"
    t.string "title"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "column_id"
    t.integer "bulk_id"
    t.integer "status"
    t.string "new_val"
    t.index ["activity_id"], name: "index_requests_on_activity_id"
    t.index ["column_id"], name: "index_requests_on_column_id"
    t.index ["initiator_id"], name: "index_requests_on_initiator_id"
    t.index ["target_id"], name: "index_requests_on_target_id"
  end

  create_table "room_bookings", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "activity_timetable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_timetable_id"], name: "index_room_bookings_on_activity_timetable_id"
    t.index ["room_id"], name: "index_room_bookings_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "table_name", force: :cascade do |t|
    t.string "email", null: false
    t.integer "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "themes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "uni_modules", force: :cascade do |t|
    t.string "code", null: false
    t.integer "level", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "credits"
    t.string "name"
    t.bigint "semester_id"
    t.index ["code"], name: "index_uni_modules_on_code"
    t.index ["semester_id"], name: "index_uni_modules_on_semester_id"
    t.index ["user_id"], name: "index_uni_modules_on_user_id"
  end

  create_table "user_invites", force: :cascade do |t|
    t.string "email", null: false
    t.integer "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "super_user", default: false, null: false
    t.boolean "analyst"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "uid"
    t.string "mail"
    t.string "ou"
    t.string "dn"
    t.string "sn"
    t.string "givenname"
    t.string "display_name"
    t.integer "role"
    t.boolean "analyst", default: false
    t.boolean "super_user", default: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "activities", "users"
  add_foreign_key "edit_requests", "columns"
end
