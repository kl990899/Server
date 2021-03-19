class ApplicationMailer < ActionMailer::Base
  default from: 'ZansMailgun@sandboxfde0c0c329ea459a9024e0a00de73421.mailgun.org' #sender
  layout 'mailer' # app/views/layouts/mailer
end
