class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :text
      t.integer :place_id
      t.datetime :activated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
