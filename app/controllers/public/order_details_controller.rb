class Public::OrderDetailsController < ApplicationController
  before_action :authenticate_user!
  def update
    @order = Order.find(params[:order_id])
    @order_detail = @order.order_details.find_by(params[:id])
    if @order_detail.update(order_detail_params) && @order_detail.in_production?
      @order.in_production!
    elsif @order.are_all_details_completed?
        @order.completed!
        # in_production preparingはmaking_statusのenum設定したもの。
    end
      redirect_to orders_path
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end

end