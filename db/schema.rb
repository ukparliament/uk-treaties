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

ActiveRecord::Schema[8.0].define(version: 0) do
  create_schema "heroku_ext"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"

  create_table "action_types", id: :serial, force: :cascade do |t|
    t.string "label", limit: 255, null: false
  end

  create_table "actions", id: :serial, force: :cascade do |t|
    t.date "action_on"
    t.date "effective_on"
    t.integer "treaty_id", null: false
    t.integer "party_id", null: false
    t.integer "action_type_id"
  end

  create_table "citations", id: :serial, force: :cascade do |t|
    t.string "citation", limit: 255, null: false
    t.integer "treaty_id", null: false
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "downcased_name", limit: 255, null: false
  end

  create_table "parties", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "downcased_name", limit: 255, null: false
  end

  create_table "signing_locations", id: :serial, force: :cascade do |t|
    t.integer "treaty_id", null: false
    t.integer "location_id", null: false
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "subject", limit: 255, null: false
  end

  create_table "treaties", id: :serial, force: :cascade do |t|
    t.string "uuid", limit: 36, null: false
    t.integer "record_id", null: false
    t.integer "treaty_id"
    t.string "title", limit: 10000, null: false
    t.string "description", limit: 10000
    t.date "signed_on"
    t.date "in_force_on"
    t.string "pdf_file_name", limit: 255
    t.integer "treaty_type_id"
    t.integer "subject_id"
  end

  create_table "treaty_parties", id: :serial, force: :cascade do |t|
    t.integer "treaty_id", null: false
    t.integer "party_id", null: false
  end

  create_table "treaty_types", id: :serial, force: :cascade do |t|
    t.string "short_name", limit: 5, null: false
    t.string "label", limit: 12, null: false
  end

  add_foreign_key "actions", "action_types", name: "fk_action_type"
  add_foreign_key "actions", "parties", name: "fk_party"
  add_foreign_key "actions", "treaties", name: "fk_treaty"
  add_foreign_key "citations", "treaties", name: "fk_treaty"
  add_foreign_key "signing_locations", "locations", name: "fk_location"
  add_foreign_key "signing_locations", "treaties", name: "fk_treaty"
  add_foreign_key "treaties", "subjects", name: "fk_subject"
  add_foreign_key "treaties", "treaty_types", name: "fk_treaty_type"
  add_foreign_key "treaty_parties", "parties", name: "fk_party"
  add_foreign_key "treaty_parties", "treaties", name: "fk_treaty"
end
