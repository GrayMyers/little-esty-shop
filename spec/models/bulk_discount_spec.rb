require "rails_helper"

describe BulkDiscount, type: :model do
  describe "relations" do
    it {should belong_to :merchant}
  end

  describe "validations" do
    it {should validate_presence_of :item_quantity}
    it {should validate_presence_of :percent_off}
  end
end
