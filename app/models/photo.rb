class Photo < ActiveRecord::Base
  has_one :post, :as => :resource
  
  # Paperclip
  has_attached_file :image,:styles => {:thumb=> "240x240#"}
end
