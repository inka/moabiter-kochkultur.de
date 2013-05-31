# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091022202623) do

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "place_id"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "contacts", :force => true do |t|
    t.string   "salutation"
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.integer  "place_id"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.integer  "lastchange_by",                                          :null => false
    t.string   "title"
    t.string   "address"
    t.string   "kiez"
    t.string   "url"
    t.string   "email"
    t.string   "phone"
    t.string   "lunch_special_available"
    t.string   "seats_inside"
    t.string   "seats_outside"
    t.text     "description"
    t.text     "opening_hours"
    t.text     "lunch_special_example"
    t.text     "menu_sample"
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating_count"
    t.decimal  "rating_total"
    t.decimal  "rating_avg",              :precision => 10, :scale => 2
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "contact_person"
    t.string   "url"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "category"
    t.string   "kind"
    t.text     "address"
    t.text     "description"
    t.text     "comment"
    t.integer  "place_id"
    t.integer  "expire_days"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer "rater_id"
    t.integer "rated_id"
    t.string  "rated_type"
    t.decimal "rating"
  end

  add_index "ratings", ["rated_type", "rated_id"], :name => "index_ratings_on_rated_type_and_rated_id"
  add_index "ratings", ["rater_id"], :name => "index_ratings_on_rater_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_name_and_sluggable_type_and_scope_and_sequence", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  create_table "users", :force => true do |t|
    t.boolean  "is_admin",                                :default => false, :null => false
    t.string   "login"
    t.string   "name"
    t.string   "email"
    t.string   "remember_token"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "activation_code",           :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.datetime "last_activity_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
