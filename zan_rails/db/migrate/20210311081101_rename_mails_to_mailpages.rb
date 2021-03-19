class RenameMailsToMailpages < ActiveRecord::Migration[5.2]
  def change
    rename_table :mails, :mailpages
  end
end
