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

ActiveRecord::Schema.define(version: 2020_09_09_150001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matchdays", force: :cascade do |t|
    t.datetime "lock_time"
    t.boolean "locked", default: false
    t.boolean "scored", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "picks", force: :cascade do |t|
    t.string "user_uid", null: false
    t.integer "matchday", null: false
    t.string "team_id", default: "", null: false
    t.integer "half", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_uid"], name: "index_picks_on_user_uid"
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string "uid", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "team_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "picks", "users", column: "user_uid", primary_key: "uid"
end
