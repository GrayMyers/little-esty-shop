class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.order(:id)
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(invoice_params)
    if invoice.status == "completed"
      invoice.invoice_items.set_discounts
    end
    redirect_to admin_invoice_path(invoice)
  end

  private
  def invoice_params
    params.permit(:status)
  end
end
