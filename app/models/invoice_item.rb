class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  belongs_to :bulk_discount, optional: true

  enum status: ["pending", "packaged", "shipped"]

  delegate :name, to: :item, prefix: true

  def self.invoice_amount
    sum('quantity * unit_price * percent_paid / 100')
  end

  def self.set_discounts #this could theoretically be done using activerecord but it would likely be horrendous
    all.each do |invoice_item| #and not within the scope of this project to do that, as it is an extension.
      discount = invoice_item.best_discount
      if discount then
          invoice_item.update(
          percent_paid: 100 - discount.percent_off,
          bulk_discount_id: discount.id
        )
      end
    end
  end

  def best_discount
    BulkDiscount #this query was initially designed to be able to get the best discounts for a set of invoice items,
    .joins(merchant: {items: :invoice_items}) #but that doesn't work here so it had to be converted to get the best discount for one.
    .select("merchants.id, bulk_discounts.*, invoice_items.quantity") #should probably refactor
    .where("bulk_discounts.item_quantity <= invoice_items.quantity AND merchants.id = #{item.merchant.id} AND invoice_items.id = #{id} AND bulk_discounts.active = 'true'")
    .order("bulk_discounts.percent_off DESC").limit(1)
    .first #no ruby to be seen here, just have to get this out of array form
  end
end
