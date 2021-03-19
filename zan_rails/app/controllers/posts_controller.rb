class PostsController < ApplicationController
  BOM = "\xEF\xBB\xBF"
  before_action :authenticate_user!
  before_action :set_post, only: %i[ show edit update destroy ]
  

  def hello
    @alpha = params
  end

  # GET /posts or /posts.json
  def index
    if params[:search]
      search = params[:search]
      @posts = Post.joins(:user).where('title LIKE ? OR content LIKE ? OR name LIKE ? ', "%#{search}%", "%#{search}%", "%#{search}%") #.where('name LIKE ?', "%#{search}%")
    else
      @posts = Post.includes(:user)
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        # 官方文件：使用deliver_later方便mail直接進入job佇列
        ContactMailer.new_post_subscribe(@post).deliver_later

        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #文章圖片編輯

  def output
    #model 取關聯 不抓表

    @users = User.all
    headers = ['使用者', '發文次數', '發文主題']

    csv_data = CSV.generate(BOM, encoding: "utf-8", headers: true) do |csv|
      csv << headers
      @users.each do |user|
        row = []
        row << user.name
        post_title = ''
        user.post.each do |post|
            post_title += post[:title] + '/'
        end
        row << user.post.count
        row << post_title
        csv << row
      end
    end
    send_data "\xEF\xBB\xBF#{csv_data}", filename: "data-#{Date.today.to_s}.csv", disposition: :attachment
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :is_available, :user_id, :pimage)
    end
end
