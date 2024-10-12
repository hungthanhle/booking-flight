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

ActiveRecord::Schema[7.0].define(version: 2024_10_12_084531) do
  create_table "administrators", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "name"
    t.string "email"
    t.integer "role", default: 0
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_administrators_on_uid_and_provider", unique: true
  end

  create_table "aircrafts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "airports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booking_directions", primary_key: "booking_direction_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "booking_id"
    t.integer "type"
    t.integer "flight_id"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booking_lines", primary_key: "line_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "booking_direction_id"
    t.integer "type"
    t.integer "seat_class"
    t.integer "quantity"
    t.float "sub_total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booking_passengers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "booking_id"
    t.integer "passenger_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", primary_key: "booking_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "type"
    t.integer "departure_flight_id"
    t.integer "destination_flight_id"
    t.integer "passenger_number"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", primary_key: "entry_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "account_number"
    t.string "sign"
    t.float "amount"
    t.integer "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", primary_key: "flight_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "aircraft_id"
    t.integer "departure_airport_id"
    t.integer "destination_airport_id"
    t.datetime "departure_date"
    t.datetime "destination_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passengers", primary_key: "passenger_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pricings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "flight_id"
    t.integer "seat_class"
    t.float "price"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seat_availabilities", primary_key: ["flight_id", "seat_code", "status"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "flight_id", null: false
    t.integer "seat_code", null: false
    t.integer "status", default: 0, null: false
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seats", primary_key: "seat_code", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "seat_class"
    t.integer "aircraft_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", primary_key: "ticket_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "flight_id"
    t.integer "passenger_id"
    t.integer "seat_code"
    t.integer "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", primary_key: "transaction_id", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "type"
    t.integer "booking_id"
    t.float "amount"
    t.integer "method"
    t.float "fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "name"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

end
