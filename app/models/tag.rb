class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_many :tags_relations, :dependent => :destroy
  has_many :posts, :through => :tags_relations
end
