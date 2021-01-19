class DiscountItem < ApplicationRecord
  belongs_to :invoice_item
  belongs_to :bulk_discount
end
