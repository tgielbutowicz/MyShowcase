# == Schema Information
# Schema version: 20110613181957
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  attr_accessor :password #virtual atribute
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :posts, :dependent => :destroy
  has_many :users_relations, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :users_relations, :source => :followed
  has_many :reverse_users_relations, :foreign_key => "followed_id",
                                   :class_name => "UsersRelation",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_users_relations, :source => :follower
  
  scope :admin, where(:admin => true) #User.admin would return an array of all the site admins.

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true, #creates virtual atribute :password_confirmation
                       :length       => { :within => 6..40 }
                       
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    #if psssword dosen't match returns nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def feed
    Post.from_users_followed_by(self)
  end
  
  def following?(followed)
    users_relations.find_by_followed_id(followed)
  end

  def follow!(followed)
    users_relations.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    users_relations.find_by_followed_id(followed).destroy
  end
  
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end
