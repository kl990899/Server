class Resume < ApplicationRecord
    mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.   
    validates :name, presence: true #資料驗證 必須包含name欄位才能上傳
    #validates :attachment, :attachment_content_type => { :content_type => ['application/csv', 'application/xlsx']}
end
