class AddPimageToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :pimage, :string, after: :content
  end
end
