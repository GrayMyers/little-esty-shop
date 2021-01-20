require "rails_helper"

describe "bulk discount creation page" do
  before :each do
    @merchant = create(:merchant)
    visit new_merchant_bulk_discount_path(@merchant.id)
  end

  it "redirects to bulk discount index upon successful creation" do
    fill_in "bulk_discount_item_quantity", with: 10
    fill_in "bulk_discount_percent_off", with: 50
    click_on "Create Discount"
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant.id))
  end

  it "stays on same page and displays error upon unsuccessful creation" do
    fill_in "bulk_discount_item_quantity", with: ""
    fill_in "bulk_discount_percent_off", with: 50
    click_on "Create Discount"

    within "#flash-messages" do
      expect(page).to have_content("Item quantity can't be blank")
    end
  end
end
