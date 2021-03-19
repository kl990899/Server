desc "A task used for sending daily mail"
task :send_daily_mail => :environment do
    @mail = Mailpage.where(been_mail: [false]).where.not(appointment: [nil])
    @mail.each do |m|
        #系統時區在搞
        t = Time.new(m.appointment.year, m.appointment.month, m.appointment.day, m.appointment.hour, m.appointment.min, 0, "+08:00")
        if t.to_time < Time.now.to_time
            ContactMailer.send_immediately(m).deliver
        end
    end
    #puts "success down task"
end