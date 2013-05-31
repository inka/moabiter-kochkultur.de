class Comment < ActiveRecord::Base
  belongs_to :place
  belongs_to :user

  acts_as_rated(:rating_range => 1..5, :rater_class => 'User')
end
