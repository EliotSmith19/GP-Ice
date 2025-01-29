class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_van, only: [:create]


  def index
    @orders = Order.where(user_id: current_user.id)
    @vans = @orders.map(&:van).uniq
    if params[:van_id].present?
      @selected_van = Van.find(params[:van_id])
      @orders = @orders.where(van_id: @selected_van.id)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @order = Order.new
    @products = Product.all
  end

  # def create
  #   @order = Order.new(order_params)
  #   if @order.save
  #     redirect_to @order, notice: "Order created successfully!"
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  def create
    @order = Order.new
    @order.user = current_user
    @order.van = @van
    @order.confirmed_status = false
    @order.paid_status = false
    @product = Product.find(params[:product_id])
    if @order.save
      OrderProduct.create(order: @order, product: @product, quantity_ordered: params[:quantity_ordered])
      redirect_to @order, notice: "Order created successfully!"
    else
      render :new, status: :unprocessable_entity

#     @order = Order.create(user: current_user, confirmed_status: false, paid_status: false)
#     if params[:product_ids].present?
#       params[:product_ids].each { |product_id| @order.order_products.create(product_id: product_id) }

    end
    redirect_to order_checkout_path(@order)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(confirmed_status: true)
      redirect_to van_orders_path(@order.van), notice: 'Order confirmed.'
    else
      redirect_to van_orders_path(@order.van), alert: 'Failed to confirm order.'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to van_orders_path(@order.van), notice: 'Order deleted.'
  end


  def checkout
    @order = Order.find(params[:order_id])

    if @order.update(confirmed_status: true)
      flash[:notice] = "Order successfully checked out!"
      render :checkout
    else
      redirect_to order_path(@order), alert: "Checkout failed."
    end
  end

  private

  def set_van
    @van = Van.find_by(id: params[:van_id])
    unless @van
      redirect_to root_path, alert: 'Van not found'
    end
  end

  #  def order_params
  #   params.require(:order).permit(:confirmed_status)
  #  end


  def order_params
    params.require(:order).permit(:confirmed_status)
  end
end
