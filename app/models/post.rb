# == Schema Information
# Schema version: 20110613181957
#
# Table name: posts
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  content       :text
#  views         :integer
#  likes         :integer
#  dislikes      :integer
#  user_id       :integer
#  resource_id   :integer
#  resource_type :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Post < ActiveRecord::Base
  attr_accessible :title, :content
  
  belongs_to :user
  
  validates :title, :presence => true, :length => { :within => 1..48 }
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  default_scope :order => 'posts.created_at DESC'
  
  # Return posts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM users_relations
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
            { :user_id => user })
    end
end
