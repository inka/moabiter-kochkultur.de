# == Schema Information
# Schema version: 20080906150046
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  is_admin                  :boolean         not null
#  login                     :string(255)
#  name                      :string(255)
#  email                     :string(255)
#  remember_token            :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  activation_code           :string(40)
#  remember_token_expires_at :datetime
#  activated_at              :datetime
#  last_activity_at          :datetime
#  created_at                :datetime
#  updated_at                :datetime
#

require 'email_veracity'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  has_many :comments

  validates_presence_of     :login
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..100
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_format_of :login, :with => EmailVeracity::Config.options[:valid_pattern]

  before_save :encrypt_password
  before_create :make_activation_code, :set_admin

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :name, :email, :password, :password_confirmation, :last_activity_at

  def validate
    unless errors.on(:login)
      address = EmailVeracity::Address.new(login)
      unless address.valid?
        errors.add(:login, "E-Mail Adresse ist nicht korrekt (#{address.errors})" )
        #errors.add(:login, 'email domain name appears to be incorrect' )
      end
    end
  end

  def nice_name
    name.blank? ? email : name
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def set_admin
    # The first user is admin automatically.
    self.is_admin = true if User.count.zero?
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def make_activation_code

    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

end
