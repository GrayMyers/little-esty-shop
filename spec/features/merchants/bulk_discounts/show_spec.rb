require "rails_helper"
describe "merchant bulk discount show page" do
  before :each do
    @merchant = create(:merchant)
    @discount = create(:bulk_discount,merchant: @merchant)
    visit merchant_bulk_discount_path(@merchant.id, @discount.id)
  end

  it "displays the properties of the bulk discount" do
    within("#properties") do
      expect(page).to have_content(@discount.percent_off)
      expect(page).to have_content(@discount.item_quantity)
    end
  end
end
