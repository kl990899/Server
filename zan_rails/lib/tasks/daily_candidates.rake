desc "A task used for sending daily mail"
task :daily_candidates => :environment do
    ContactMailer.daily_candidates.deliver
end