# :users, :artists, :events, :posts
class CreateTables < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.boolean   :is_admin, :null => false, :default => false
      t.string    :login, :name, :email, :remember_token
      t.string    :crypted_password, :salt, :activation_code, :limit => 40
      t.datetime  :remember_token_expires_at, :activated_at, :last_activity_at
      t.timestamps
    end

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    create_table "posts" do |t|
      t.string :title, :contact_person, :url, :email, :crypted_password, :salt, :category, :kind
      t.text   :address, :description, :comment
      t.integer :place_id, :expire_days
      t.datetime :activated_at
      t.timestamps
    end

    create_table :contacts do |t|
      t.string :salutation, :name, :email
      t.text :message

      t.timestamps
    end

    create_table :places do |t|
      t.column :lastchange_by, :integer, :null => false
      t.string :title, :address, :kiez, :url, :email, :phone, :lunch_special_available, :seats_inside, :seats_outside
      t.text :description, :opening_hours, :lunch_special_example, :menu_sample
      t.decimal :lat, :lng
      t.timestamps
    end
    # acts_as_rated plugin 
    ActiveRecord::Base.create_ratings_table
    Place.add_ratings_columns

    create_table :pictures do |t|
      t.integer :place_id, :parent_id, :size, :width, :height
      t.string :content_type, :filename, :thumbnail
      t.timestamps
    end
  end

  def self.down
    [:users, :sessions, :posts, :contacts, :places, :pictures
    ].each do |table|
      begin
        drop_table table
      rescue => boom
        puts boom
      end
    end
    ActiveRecord::Base.drop_ratings_table
  end
end
