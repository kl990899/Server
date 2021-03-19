class MailpagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mail, only: %i[ show edit update destroy ]

  def index
    @mails = Mailpage.all.order('created_at DESC')
    @mails = Kaminari.paginate_array(@mails).page(params[:page]).per(8)
    #@mailpages = Mailpage.page(params['page'])
  end

  def new
    @mail = Mailpage.new
  end

  def edit
  end
  
  def show
  end

  def create
    @mail = Mailpage.new(mail_params)
    #因mailgun尚未註冊domain name，故先以測試信箱為常值
    @mail.addressee = "kl990899@amastek.com"
    t = Time.new(@mail.appointment.year, @mail.appointment.month, @mail.appointment.day, @mail.appointment.hour, @mail.appointment.min, 0, "+08:00")
    if @mail.appointment.blank? || t.to_time < Time.now.to_time
      ContactMailer.send_immediately(@mail).deliver_now
      puts '>>>>>>>>>>mail is already sent!<<<<<<<<<<'
      @mail.been_mail = true
      @mail.appointment = nil
    else
      @mail.been_mail = false
    end
    #寄出後存進資料庫
    if @mail.save
      redirect_to mailpages_path, notice: "Successfully uploaded."   
    else
      #error message?
      render "new"   
    end

  end

  private
    def set_mail
      @mail = Mailpage.find(params[:id])
    end

    def mail_params   
      params.require(:mailpage).permit(:sender, :addressee, :subject, :content, :attachment_file, :appointment)   
    end

end
