class BulkDiscount < ApplicationRecord
  validates_presence_of :percent_off, :item_quantity

  belongs_to :merchant
end
