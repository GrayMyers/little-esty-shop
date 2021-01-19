class BulkDiscount < ApplicationRecord
  validates_presence_of :percent_off, :item_quantity

  belongs_to :merchant

  def disable
    update(active: false)
  end

  def self.enabled #had to be word other than active
    where(active: true)
  end
end
