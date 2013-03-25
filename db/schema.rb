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

ActiveRecord::Schema.define(:version => 20141005220858) do

  create_table "accounts", :force => true do |t|
    t.decimal  "balance"
    t.date     "payment_due_date"
    t.integer  "state"
    t.integer  "member_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "accounts", ["member_id"], :name => "index_accounts_on_member_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "klasses", :force => true do |t|
    t.string   "day_of_week"
    t.datetime "class_time"
    t.string   "name"
    t.boolean  "recurring",   :default => true
    t.integer  "studio_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "klasses", ["studio_id"], :name => "index_klasses_on_studio_id"

  create_table "levels", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "studio_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "levels", ["studio_id"], :name => "index_levels_on_studio_id"

  create_table "member_notes", :force => true do |t|
    t.text     "body"
    t.integer  "member_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "member_notes", ["member_id"], :name => "index_notes_on_member_id"

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.date     "birthday"
    t.boolean  "active",           :default => true
    t.string   "image"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "membership_type"
    t.decimal  "membership_price"
    t.integer  "studio_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "level_id"
    t.integer  "source_id"
  end

  add_index "members", ["level_id"], :name => "index_members_on_level_id"
  add_index "members", ["source_id"], :name => "index_members_on_source_id"
  add_index "members", ["studio_id"], :name => "index_members_on_studio_id"

  create_table "payments", :force => true do |t|
    t.date     "due_date"
    t.date     "payment_date"
    t.decimal  "amount_due"
    t.decimal  "payment_amount"
    t.string   "payment_method"
    t.integer  "account_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "payments", ["account_id"], :name => "index_payments_on_account_id"

  create_table "settings_members", :force => true do |t|
    t.integer  "default_payment_due_day",         :default => 1
    t.boolean  "default_payment_due_day_enabled", :default => false
    t.integer  "studio_id"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "settings_members", ["studio_id"], :name => "index_settings_members_on_studio_id"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.integer  "studio_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sources", ["studio_id"], :name => "index_member_sources_on_studio_id"

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "time_zone"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.boolean  "admin"
    t.boolean  "owner"
    t.integer  "studio_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["studio_id"], :name => "index_users_on_studio_id"

  create_table "visits", :force => true do |t|
    t.date     "visit_date"
    t.integer  "member_id"
    t.integer  "klass_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "visits", ["klass_id"], :name => "index_visits_on_klass_id"
  add_index "visits", ["member_id"], :name => "index_visits_on_member_id"

end
