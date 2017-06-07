class ProductsController < ApplicationController
  # before_action :authenticate_user!, :only, [:new, :edit, :create, :update, :destroy]
  before_action :validate_search_key, only: [:search]
  def index
    @products = Product.all.order("position ASC")
    if params[:category].blank?
      @products = Product.all
    else
      @category_id = Category.find_by(name: params[:category]).id
      @products = Product.where(:category_id => @category_id)
    end
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.find(params[:id])
    @photos = @product.photos.all
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to carts_path, notice: "Update success."
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path, alert: "Product deleted."
  end

  def add_to_cart
    @product = Product.find(params[:id])
    if !current_cart.products.include?(@product)
      current_cart.add_product_to_cart(@product)
      flash[:notice] = "你已成功将 #{@product.title} 加入实验室"
    else
      flash[:warning] = "实验室内已有此底料"
    end
    redirect_to :back
  end

  def lucky_cart
    current_cart.clean!

    @products = Product.random5
    @products.each do |product|
      current_cart.add_product_to_cart(product)
    end
    redirect_to carts_path, notice:"霖霖赞你好手气~"
  end

# 搜索
  def search
    if @query_string.present?
      search_result = Product.ransack(@search_criteria).result(:distinct => true)
      @products = search_result.paginate(:page => params[:page], :per_page => 5 )
    end
  end


  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria = search_criteria(@query_string)
    end
  end


  def search_criteria(query_string)
    { :title_cont => query_string }
  end

# 搜索

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity, :salt, :sugar, :papper, :sauces, :vinegar, :oil)
  end
end
