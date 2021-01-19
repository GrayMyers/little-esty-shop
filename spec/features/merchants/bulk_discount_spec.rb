require "rails_helper"

describe "merchant bulk discounts index page" do
  before :each do
    @merchant = create(:merchant)
    @discounts = create_list(:bulk_discount,5,merchant_id: @merchant.id)
    @not_discounts = create_list(:bulk_discount,5)
    visit merchant_bulk_discounts_path(@merchant.id)
  end

  it "lists all merchant discounts" do
    @discounts.each do |discount|
      within("#discount-#{discount.id}") do
        expect(page).to have_content(discount.percent_off)
        expect(page).to have_content(discount.item_quantity)
      end
    end
  end

  it "has links to each discount's show page" do
    @discounts.each do |discount|
      within("#discount-#{discount.id}") do
        click_on "See Details"
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id,discount.id))
      end
      visit merchant_bulk_discounts_path(@merchant.id)
    end
  end

  it "does not have discounts for other merchants" do
    @not_discounts.each do |discount|
      expect(page).to_not have_css("#discount-#{discount.id}")
    end
  end
end
