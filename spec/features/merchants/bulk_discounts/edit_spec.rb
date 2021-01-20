require "rails_helper"

describe "bulk discounts edit page" do
  before :each do
    @merchant = create(:merchant)
    @discount = create(:bulk_discount)
    visit edit_merchant_bulk_discount_path(@merchant.id,@discount.id)
  end

  it "has the properties of the discount prepopulated" do
    expect(page).to have_content(@discount.percent_off)
    expect(page).to have_content(@discount.item_quantity)
  end

  it "redirects to show page upon successful submission" do
    fill_in "bulk_discount_item_quantity", with: 10
    click_on "Create Discount"
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant.id))
  end

  it "displays form with flash message upon unsuccessful submission" do
    fill_in "bulk_discount_item_quantity", with: ""
    click_on "Create Discount"

    within "#flash-messages" do
      expect(page).to have_content("Item quantity can't be blank")
    end
  end
end
