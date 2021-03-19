class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: [:edit, :update, :destroy]

  def index
    @products = Product.all
    @product = Product.new
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "新增商品完成"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "商品更新成功"
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "商品已刪除"
  end

  def import
    products = Product.all

    repeat_title = []
    if params[:table].present?
      uploaded_io = params[:table]
      file_name = uploaded_io.original_filename
      file_path = uploaded_io.path

      case File.extname(file_name)
      when ".csv"
        csv_text = File.read(file_path)
        @csv = CSV.parse(csv_text, :headers => true)
        @csv.each do |row|
          repeat_title << check_repeat_and_new(products, row.to_hash)
        end
      when ".xlsx"
        xlsx  = Roo::Spreadsheet.open(file_path)
        headers = xlsx.row(1) # get header row
        xlsx.each_with_index do |row, idx|
          next if idx == 0 
          xlsx_row = Hash[[headers, row].transpose]
          xlsx_row.transform_values! { |v| v.nil? || !v ? "" : v }
          repeat_title << check_repeat_and_new(products, xlsx_row)
        end
      else
        raise "Unknown file type: #{File.extname(file_name)}"
      end
    end

    redirect_to products_path, notice: "#{u_t = repeat_title.count(nil)}項商品匯入成功，#{repeat_title.size - u_t}項商品被更新"
  end

  private
  def check_repeat_and_new(products, row)
    products.each_with_index do |product, idx|
      if (product[:title] == row["title"])
        Product.find_by(title: product[:title]).update(row)
        return row["title"]
      end
    end
    @new_product= Product.new(row)
    @new_product.save

    return nil
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    redirect_to products_path, notice: "無此商品" unless @product
  end

  def product_params
    params.require(:product).permit(:title, :description, :price)
  end

end