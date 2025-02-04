class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.find_by(id: params[:order_id], status: 'pending')

    if @order.nil?
      redirect_to orders_path, alert: "Order not found or already paid."
    end
  end
end
