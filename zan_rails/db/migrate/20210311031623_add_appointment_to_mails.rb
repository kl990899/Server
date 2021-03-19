class AddAppointmentToMails < ActiveRecord::Migration[5.2]
  def change
    add_column :mails, :appointment, :datetime, after: :attachment_file
  end
end
