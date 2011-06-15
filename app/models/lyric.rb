class Lyric < ActiveRecord::Base
  has_one :post, :as => :resource
  
end
