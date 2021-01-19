require "rails_helper"

describe DiscountItem, type: :model do
  describe "relations" do
    it {should belong_to :invoice_item}
    it {should belong_to :bulk_discount}
  end
end
