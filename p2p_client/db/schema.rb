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

ActiveRecord::Schema.define(:version => 20120426231559) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "biddings", :force => true do |t|
    t.datetime "bid_time"
    t.integer  "bid_amount"
    t.string   "ipaddress"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
  end

  create_table "bitcoins", :force => true do |t|
    t.integer  "itemid"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", :force => true do |t|
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parentID"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_members", :force => true do |t|
    t.string   "ipAddress"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "ipaddresses", :force => true do |t|
    t.string   "ipaddress"
    t.string   "iptype"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "condition"
    t.decimal  "starting_price"
    t.integer  "duration"
    t.string   "category"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "expires_at"
    t.boolean  "bidding_closed"
    t.boolean  "is_paid"
    t.boolean  "for_sale"
    t.decimal  "buy_price"
  end

  create_table "line_items", :force => true do |t|
    t.decimal  "unit_price"
    t.integer  "item_id"
    t.integer  "cart_id"
    t.integer  "quantity"
    t.boolean  "item_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mydata", :force => true do |t|
    t.string   "email"
    t.string   "localaddress"
    t.boolean  "is_seller"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "item_id"
    t.boolean  "delivered"
    t.string   "ipaddress"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message"
    t.string   "notification_type"
  end

  create_table "orders", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.string   "street"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.integer  "phone"
    t.string   "country"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searchdbs", :force => true do |t|
    t.string   "buyeripaddress"
    t.string   "searchquery"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "keywords"
    t.integer  "category_id"
    t.float    "minimum_price"
    t.float    "maximum_price"
    t.datetime "ending_time"
    t.boolean  "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seller_email"
  end

  create_table "searchresults", :force => true do |t|
    t.string   "search_string"
    t.string   "category"
    t.string   "ipaddress"
    t.string   "returned_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sellerrings", :force => true do |t|
    t.string   "ipaddress"
    t.string   "iptype"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shippinginfos", :force => true do |t|
    t.integer  "itemid"
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.integer  "phone"
    t.string   "country"
    t.date     "dob"
    t.boolean  "is_seller"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "watchlists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
