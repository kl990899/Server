class Mailpage < ApplicationRecord
    mount_uploader :attachment_file, AttachmentFileUploader # Tells rails to use this uploader for this model.   
    #validates :sender, format: { with: URI::MailTo::EMAIL_REGEXP } 信箱格式認證

end
