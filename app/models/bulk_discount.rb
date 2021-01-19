class BulkDiscount < ApplicationRecord
  validates_presence_of :percent_off, :item_quantity

  belongs_to :merchant
  has_many :discount_items
  has_many :invoice_items, through: :discount_items
end
