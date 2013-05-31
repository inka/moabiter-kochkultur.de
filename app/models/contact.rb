# == Schema Information
# Schema version: 20090709192250
#
# Table name: contacts
#
#  id         :integer         not null, primary key
#  salutation :string(255)
#  name       :string(255)
#  email      :string(255)
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#  kiez       :string(255)
#

class Contact < ActiveRecord::Base
  validates_presence_of :name, :email, :message
  validates_format_of :email, :with => EmailVeracity::Config.options[:valid_pattern]
end
