class CoffeesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @coffees = User.all
    
    respond_to do |format|
      format.html
      format.csv { send_data @coffees.to_csv(:only => [:name, :email, :tel]) }
      format.pdf do
        render :pdf => "pdf", :template => 'coffees/pdf.html.erb',
        show_as_html: params.key?('debug'),
        locals: {:coffees => @coffees}
      end
    end
  end

  #router 與 csv index衝突? 導致抓不到axlsx template 導致xlsx輸出異常
  def action
    @buttons = User.all
    respond_to do |format|
      format.xlsx
    end
  end

  def import
    @resume = Resume.find(params[:id])
    name = @resume.attachment.to_s
    file_path = "public/uploads/resume/attachment/#{params[:id]}/#{@resume[:attachment]}"

    case File.extname(name)
    when ".csv" 
      csv_text = File.read(file_path)
      @csv = CSV.parse(csv_text, :headers => true)
      @csv.each do |row|
        puts row.to_hash
        @user= User.new(row.to_hash)
        @user.save!(:validate => false)
      end
    when ".xlsx" 
      data  = Roo::Spreadsheet.open(file_path)
      headers = data.row(1) # get header row

      data.each_with_index do |row, idx|
        next if idx == 0 # skip header
        # create hash from headers and cells
        user_data = Hash[[headers, row].transpose]
        user_data.transform_values! { |v| v.nil? || !v ? "" : v }
        puts user_data
        @user= User.new(user_data)
        @user.save!(:validate => false)
      end
    else 
      raise "Unknown file type: #{File.extname(name)}"
    end

    redirect_to users_url, notice: "匯入成功"
  end
end



