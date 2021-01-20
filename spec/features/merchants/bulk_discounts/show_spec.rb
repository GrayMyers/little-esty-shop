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

  it "has a link to edit the discount's properties" do
    click_on "Edit Discount"
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id,@discount.id))
  end
end
