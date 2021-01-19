class Merchants::BulkDiscountsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    @discounts = merchant.bulk_discounts.enabled 
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
  end

  def create
    @discount = BulkDiscount.new(discount_params)
    if @discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    else
      flash.alert = @discount.errors.full_messages
      @merchant = Merchant.find(params[:merchant_id])
      render "new"
    end
  end

  def destroy
    @discount = BulkDiscount.find(params[:id])
    @discount.disable
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:percent_off, :item_quantity).merge(merchant_id: params[:merchant_id])
  end
end
