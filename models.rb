class User < ActiveRecord::Base

  def full_name
    fname + " " + lname
  end

  def location
    city + ", " + state
  end

  has_many :tweets
end

class Tweet < ActiveRecord::Base

  belongs_to :user
end