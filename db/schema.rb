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

ActiveRecord::Schema.define(version: 2020_12_21_064616) do

  create_table "Workers", primary_key: "idWorkers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "Name", limit: 300
    t.string "Phone", limit: 5
  end

  create_table "aggregated_calls", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.date "calldate"
    t.integer "quantity_all"
    t.integer "quantity_in"
    t.integer "quantity_out"
    t.integer "received"
    t.integer "missed"
    t.index ["calldate"], name: "index_aggregated_calls_by_calldate", unique: true
  end

  create_table "clients", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "company", limit: 45, collation: "latin1_swedish_ci"
    t.string "phone_number", limit: 45, collation: "latin1_swedish_ci"
  end

  create_table "internal_numbers", id: :string, limit: 3, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "operator", limit: 20, default: ""
    t.index ["id"], name: "id_UNIQUE", unique: true
  end

  create_table "search_requests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "username"
    t.string "user_phone"
    t.string "client_name"
    t.string "client_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_search_requests_on_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
