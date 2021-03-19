class Post < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  mount_uploader :pimage, PimageUploader # Tells rails to use this uploader for this model.   
end
