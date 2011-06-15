class Photo < ActiveRecord::Base
  has_one :post, :as => :resource
end
