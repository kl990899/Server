class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    extend Devise::Models
    
  has_many :post, foreign_key: "user_id"

  def self.to_csv(records = [], options = {})
    column_names = %w{name email tel encrypted_password}
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
  

  
end
