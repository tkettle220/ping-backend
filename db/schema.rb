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

ActiveRecord::Schema.define(version: 20171013180624) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chatrooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chatroom_id", null: false
    t.index ["chatroom_id"], name: "index_friendships_on_chatroom_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude", precision: 15, scale: 10
    t.decimal "longitude", precision: 15, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude"
    t.index ["latitude"], name: "index_locations_on_latitude"
    t.index ["longitude"], name: "index_locations_on_longitude"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.integer "chatroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pending_friendships", force: :cascade do |t|
    t.integer "requester_id", null: false
    t.integer "requestee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["requestee_id"], name: "index_pending_friendships_on_requestee_id"
    t.index ["requester_id", "requestee_id"], name: "index_pending_friendships_on_requester_id_and_requestee_id", unique: true
    t.index ["requester_id"], name: "index_pending_friendships_on_requester_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "value", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "facebook_id", null: false
    t.string "session_token", null: false
    t.integer "location_id"
    t.integer "visible_radius", default: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "pro_pic_url"
    t.boolean "findable", default: true
    t.string "custom_ping_icons", default: ["emergency", "home", "food"], array: true
    t.string "custom_ping_messages", default: ["Are you ok?", "Hey, are you home?", "Hey, want to get food?"], array: true
    t.index ["facebook_id"], name: "index_users_on_facebook_id"
    t.index ["location_id"], name: "index_users_on_location_id"
    t.index ["session_token"], name: "index_users_on_session_token"
  end

end
