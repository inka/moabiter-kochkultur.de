# == Schema Information
# Schema version: 20090709192250
#
# Table name: places
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  address     :string(255)
#  size        :decimal(, )
#  price       :decimal(, )
#  price2      :decimal(, )
#  totalprice  :decimal(, )
#  url         :string(255)
#  email       :string(255)
#  phone       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Place < ActiveRecord::Base
  has_many :pictures, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  acts_as_rated(:rating_range => 1..5, :rater_class => 'User')
  # http://github.com/jviney/acts_as_taggable_on_steroids/tree/master
  acts_as_taggable
  # http://geokit.rubyforge.org/readme.html
  acts_as_mappable :default_units => :kms
  # SEO stuff
  #has_friendly_id :title, :use_slug => true, :strip_diacritics => true
  has_friendly_id :title, :use_slug => true do |text|
    Slug::normalize(Slug::strip_diacritics(text)) + "-Berlin-Moabit"
  end

  before_validation :geocode_address

  private
  def geocode_address
    geo=Geokit::Geocoders::GoogleGeocoder.geocode(address, :bias => :de)
    errors.add(:address, "Adresskoordinaten für google maps nicht gefunden!") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end
end
