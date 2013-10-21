class User < ActiveRecord::Base

  def full_name
    fname + " " + lname
  end

  def location
    city + ", " + state
  end

  has_many :tweets
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :relationships
  has_many :followeds, through: :relationships
end

class Tweet < ActiveRecord::Base

  belongs_to :user
end


class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates_uniqueness_of :follower_id, scope: :followed_id
end