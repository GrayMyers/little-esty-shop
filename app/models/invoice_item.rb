class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :discount_items
  has_many :bulk_discounts, through: :discount_items

  enum status: ["pending", "packaged", "shipped"]

  delegate :name, to: :item, prefix: true

  def self.invoice_amount
    sum('quantity * unit_price')
  end
end
