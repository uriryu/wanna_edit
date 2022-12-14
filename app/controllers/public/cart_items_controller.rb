class Public::CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_item, only: [:create, :update, :destroy]
  def index
    @cart_items = current_user.cart_items.includes(:skill)
  end

  def create
    if @cart_item
      new_amount = @cart_item.amount + cart_item_params[:amount]
      @cart_item.update(amount: new_amount)
      redirect_to cart_items_path
    else
      @cart_item = current_user.cart_items.new(cart_item_params)
      @cart_item.skill_id = @skill.id
      if @cart_item.save
        redirect_to cart_items_path
      else
        render 'public/skills/show'
      end
    end
  end

  def update
    @cart_item.update(cart_item_params) if @cart_item
    redirect_to cart_items_path
  end

  def destroy
    @cart_item.destroy if @cart_item
    redirect_to cart_items_path
  end

  def destroy_all
    current_user.cart_items.destroy_all
    redirect_to cart_items_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount)
  end

  def set_cart_item
    @skill = Skill.find(params[:skill_id])
    @cart_item = current_user.has_in_cart(@skill)
  end
end
