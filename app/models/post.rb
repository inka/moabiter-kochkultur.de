# == Schema Information
# Schema version: 20090709192250
#
# Table name: posts
#
#  id               :integer         not null, primary key
#  title            :string(255)
#  contact_person   :string(255)
#  url              :string(255)
#  email            :string(255)
#  crypted_password :string(255)
#  salt             :string(255)
#  category         :string(255)
#  kind             :string(255)
#  address          :text
#  description      :text
#  comment          :text
#  expire_days      :integer
#  activated_at     :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

require 'email_veracity'
class Post < ActiveRecord::Base

  belongs_to :place

  acts_as_rated(:rating_range => 1..5, :rater_class => 'User')  

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  CATEGORIES = %w[Gewerbe Gewerbegemeinschaft Sonstiges]
  KINDS = %w[Suche Biete]
  EXPIRES = {
      '1 Woche' => 7,
      '1 Monat' => 31,
      '3 Monate' => 93,
      '12 Monate' => 365}

  validates_presence_of :title
  validates_length_of :title, :maximum => 30, :allow_nil => true
  validates_presence_of :description
  validates_length_of :description, :maximum => 350, :allow_nil => false
  validates_presence_of :kind
  validates_length_of :kind, :maximum => 5, :allow_nil => false
  validates_presence_of :category
  validates_presence_of :expire_days
  validates_length_of :url, :maximum => 50, :allow_nil => true
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :allow_nil => true, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?

  validates_length_of :email, :maximum => 50, :allow_nil => true
  validates_format_of :email, :with => EmailVeracity::Config.options[:valid_pattern]

  before_save :encrypt_password

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  # attr_accessible :login, :name, :password, :password_confirmation, :last_activity_at

  def validate
    unless errors.on(:email)
      address = EmailVeracity::Address.new(email)
      unless address.valid?
        errors.add(:email, "E-Mail Adresse ist nicht korrekt (#{address.errors})" )
      end
    end
  end

  def authenticated?(password)
#    puts "1="+crypted_password
#    puts "2="+encrypt(password)
    crypted_password == encrypt(password)
  end
  
  protected

  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{rand()}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    #crypted_password.blank? || !password.blank?
    !password.blank?
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
end
