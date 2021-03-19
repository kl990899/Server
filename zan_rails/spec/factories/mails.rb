FactoryBot.define do
  factory :mail do
    addressee { "MyString" }
    sender { "MyString" }
    been_mail { false }
    subject { "MyText" }
    content { "MyText" }
    attachment_file { "MyString" }
  end
end
