class CreateMails < ActiveRecord::Migration[5.2]
  def change
    create_table :mails do |t|
      t.string :addressee
      t.string :sender
      t.boolean :been_mail
      t.text :subject
      t.text :content
      t.string :attachment_file

      t.timestamps
    end
  end
end
