class BulkDiscount < ApplicationRecord
  validates_presence_of :percent_off, :item_quantity

  has_many :invoice_items
  belongs_to :merchant
end
