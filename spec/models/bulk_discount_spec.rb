require "rails_helper"

describe BulkDiscount, type: :model do
  describe "relations" do
    it {should belong_to :merchant}
  end

  describe "validations" do
    it {should validate_presence_of :item_quantity}
    it {should validate_presence_of :percent_off}
  end

  describe "instance methods" do
    it "disable" do
      @discount = create(:bulk_discount)
      @discount.disable
      expect(@discount.active).to eq(false)
    end
  end

  describe "class methods" do
    it "enabled" do
      @discounts = create_list(:bulk_discount, 5)
      @not_discounts = create_list(:bulk_discount, 5, active: false)
      expect(BulkDiscount.enabled.to_a).to include(@discounts[0]) #this was returning a nested array for some reason
      expect(BulkDiscount.enabled.to_a).not_to include(@not_discounts[0])
    end
  end
end
