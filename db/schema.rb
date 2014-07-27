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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140717020039) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "categories", :force => true do |t|
    t.integer  "menu_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "token"
    t.integer  "vendor_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "restaurant_id"
  end

  create_table "hours", :force => true do |t|
    t.string   "opening_time"
    t.string   "closing_time"
    t.integer  "day"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "restaurant_id"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "price",       :limit => 8
    t.string   "item_type"
    t.boolean  "requires_id"
    t.boolean  "nut_allergy"
    t.boolean  "vegetarian"
    t.integer  "category_id"
    t.boolean  "sold_out",                 :default => false
    t.text     "description"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.string   "type"
    t.string   "registration_code"
    t.boolean  "open"
    t.boolean  "add_tax",                                         :default => false
    t.decimal  "tax",               :precision => 6, :scale => 6
    t.boolean  "cash_only",                                       :default => false
    t.integer  "initial_state",                                   :default => 0
    t.integer  "shnack_fee",                                      :default => 50
    t.integer  "shnack_percent",                                  :default => 5
    t.boolean  "hide_when_closed",                                :default => false
    t.string   "bank_account_id"
  end

  create_table "locations_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "location_id"
  end

  create_table "menus", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "vendor_id"
    t.integer  "restaurant_id"
  end

  create_table "modifiers", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "item_id"
    t.integer  "mod_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "options_order_modifiers", :force => true do |t|
    t.integer "order_modifier_id"
    t.integer "option_id"
  end

  create_table "order_items", :force => true do |t|
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "order_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "order_modifiers", :force => true do |t|
    t.integer  "order_item_id"
    t.integer  "quantity"
    t.integer  "modifier_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "order_states", :force => true do |t|
    t.integer  "order_id"
    t.integer  "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "charge_id"
    t.integer  "subtotal"
    t.integer  "vendor_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "details"
    t.boolean  "paid",          :default => false
    t.integer  "restaurant_id"
    t.integer  "total"
    t.string   "slug"
    t.string   "slug_id"
    t.integer  "order_number"
    t.integer  "user_info_id"
    t.integer  "shnack_cut",    :default => 0
    t.integer  "location_cut"
    t.boolean  "withdrawn",     :default => false
    t.integer  "transfer_id"
  end

  add_index "orders", ["slug"], :name => "index_orders_on_slug", :unique => true

  create_table "restaurants", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_super",   :default => false
    t.integer  "role_type",  :default => 0
    t.integer  "user_id"
    t.integer  "stadium_id"
  end

  create_table "stadia", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "transfers", :force => true do |t|
    t.string   "transfer_id"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_infos", :force => true do |t|
    t.string   "email"
    t.string   "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "authentication_token"
    t.string   "number"
    t.string   "customer_id"
    t.string   "name"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "stadium_id"
    t.integer  "role_id"
    t.string   "registration_code"
    t.boolean  "add_tax",                                         :default => false
    t.decimal  "tax",               :precision => 6, :scale => 6
    t.boolean  "cash_only",                                       :default => false
    t.integer  "initial_state",                                   :default => 0
    t.integer  "shnack_fee",                                      :default => 50
    t.integer  "shnack_percent",                                  :default => 5
    t.string   "bank_account_id"
  end

end
