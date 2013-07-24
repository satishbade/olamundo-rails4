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

ActiveRecord::Schema.define(:version => 20130618104754) do

  create_table "categories", :force => true do |t|
    t.string   "category_name"
    t.integer  "member_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "sequence"
    t.string   "category_image_file_name"
    t.string   "category_image_content_type"
    t.integer  "category_image_file_size"
    t.datetime "category_image_updated_at"
    t.string   "image_url"
    t.string   "background_color"
    t.string   "hebrew"
    t.boolean  "default_skb"
  end

  create_table "category_symbols", :force => true do |t|
    t.integer  "category_id"
    t.integer  "sequence"
    t.string   "word"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ipad_devises", :force => true do |t|
    t.text     "devise_token"
    t.string   "status"
    t.integer  "member_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "relationship"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "image_url"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "messages", :force => true do |t|
    t.string   "message_from"
    t.string   "message_to"
    t.text     "message"
    t.integer  "message_time"
    t.string   "read"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "user_contact_id"
    t.integer  "receiver_user_contact_id"
    t.string   "message_type"
  end

  create_table "related_symbols", :force => true do |t|
    t.string   "symbol_text"
    t.integer  "symbol1_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "relatedsymbols", :force => true do |t|
    t.integer  "symbol1_id"
    t.string   "symbol_text"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "symbol_image_file_name"
    t.string   "symbol_image_content_type"
    t.integer  "symbol_image_file_size"
    t.datetime "symbol_image_updated_at"
    t.string   "image_url"
    t.integer  "sequence"
    t.string   "hebrew"
  end

  create_table "symbol1s", :force => true do |t|
    t.integer  "category_id"
    t.integer  "sequence"
    t.string   "word"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "symbol_image_file_name"
    t.string   "symbol_image_content_type"
    t.integer  "symbol_image_file_size"
    t.datetime "symbol_image_updated_at"
    t.string   "image_url"
    t.string   "symbol_type"
    t.string   "hebrew"
    t.integer  "level"
  end

  create_table "symbol_banks", :force => true do |t|
    t.string   "symbol_name"
    t.string   "image_name"
    t.string   "image_url"
    t.string   "symbol_image_file_name"
    t.string   "symbol_image_content_type"
    t.integer  "symbol_image_file_size"
    t.datetime "symbol_image_updated_at"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "user_contacts", :force => true do |t|
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "member_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "verification_code"
    t.string   "status"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
