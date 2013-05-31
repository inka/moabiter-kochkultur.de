# == Schema Information
# Schema version: 20090709192250
#
# Table name: pictures
#
#  id           :integer         not null, primary key
#  place_id     :integer
#  parent_id    :integer
#  size         :integer
#  width        :integer
#  height       :integer
#  content_type :string(255)
#  filename     :string(255)
#  thumbnail    :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Picture < ActiveRecord::Base
  belongs_to :place

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 4.megabyte,
                 :resize_to => '640x480>',
                 :thumbnails => { :thumb => '160x120>' }
  #, :processor => :MiniMagick # on local macosx dev system
  #, :processor => :RMagick    # on live debian system

  validates_as_attachment
end
