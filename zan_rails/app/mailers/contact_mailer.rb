class ContactMailer < ApplicationMailer
    def say_hello_to(user)
        @user = user
        puts @user
        mail to:@user.email, subject:"你好!!"
    end

    def send_immediately(mail)
        @mail = mail
        
        if !mail.attachment_file.blank?
            sleep 3
            attachments[mail.attachment_file.file.filename] = File.read('public' + mail.attachment_file.url)
            mail(
                from: @mail.sender + "@sandboxfde0c0c329ea459a9024e0a00de73421.mailgun.org", #測試信箱無法使用自訂寄件人
                to: @mail.addressee,
                subject: @mail.subject.to_s
            )
        else
            sleep 3
            mail(
                from: @mail.sender + "@sandboxfde0c0c329ea459a9024e0a00de73421.mailgun.org", #測試信箱無法使用自訂寄件人
                to: @mail.addressee,
                subject: @mail.subject.to_s
            )
        end
        
        @mail.been_mail = true
        @mail.save
    end
    
    def new_post_subscribe(post)
        @post = post
        @user = User.find(post.user_id)

        mail(
            from: @user.name + "@sandboxfde0c0c329ea459a9024e0a00de73421.mailgun.org", #測試信箱無法使用自訂寄件人
            to: 'kl990899@amastek.com', #因mailgun為測試帳號故暫不能使用@user.email
            subject: "訂閱報更新搂：" + @post.title.to_s
        )
    end

    def daily_candidates
        # 去model拉資料 整理後輸出成CSV PDF 然後attachments 之後mail
        @candidates = Candidate.all
        # 如何夾帶多個檔案？ minitype? 直接attachments 兩個不同的試試
        
        headers = ['姓名', '年齡', '政黨', '得票數']
        csv_data = CSV.generate(headers: true) do |csv|
            csv << headers
            @candidates.each do |people|
                csv << [people.name, people.age, people.party, people.vote_logs_count]
            end
        end
        attachments["投票報表.csv"] = {mime_type: 'text/csv', content: csv_data}
        attachments["投票報表2.pdf"] = WickedPdf.new.pdf_from_string(
            render_to_string(:pdf => "pdf",:template => 'candidates/pdf.html.erb')
          )
        mail(
            from: "candidatesMember" + "@sandboxfde0c0c329ea459a9024e0a00de73421.mailgun.org", #測試信箱無法使用自訂寄件人
            to: 'kl990899@amastek.com', #因mailgun為測試帳號故暫不能使用@user.email
            subject: "訂閱報更新搂："
        )

    end
end
