require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  let!(:merchant) {create(:merchant)}

  describe "displays" do
    it "the merchant name" do
      visit dashboard_merchant_path(merchant)

      expect(page).to have_content(merchant.name)
    end

    it "link to merchant's item index" do
      visit dashboard_merchant_path(merchant)

      click_link "My Items"

      expect(current_path).to eq(merchant_items_path(merchant))
    end

    it "link to merchant's invoices index" do
      visit dashboard_merchant_path(merchant)

      click_link "My Invoices"

      expect(current_path).to eq(merchant_invoices_path(merchant))
    end

    it "link to merchant's discounts index" do
      visit dashboard_merchant_path(merchant)

      click_link "My Discounts"

      expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
    end
  end

  describe "has section for" do
    describe "Favorite Customers" do
      let!(:top_customers)  {[
          create(:customer, :with_transactions, successful: 6, merchant: merchant),
          create(:customer, :with_transactions, successful: 5, merchant: merchant),
          create(:customer, :with_transactions, successful: 4, merchant: merchant),
          create(:customer, :with_transactions, successful: 3, merchant: merchant),
          create(:customer, :with_transactions, successful: 2, merchant: merchant),
        ]}

      it "listing the top 5 customers, with purchase counts, in order" do
        not_top = create(:customer, :with_transactions, successful: 1, merchant: merchant)

        visit dashboard_merchant_path(merchant)

        expect(page).not_to have_content("#{not_top.first_name} #{not_top.last_name}")
        within "#top_customers" do
          top_customers.each_with_index do |customer, index|
            expect(page).to have_content("#{customer.first_name} #{customer.last_name}")
            expect(page).to have_content("#{6 - index} purchase(s)")
          end
          expect(top_customers[0].last_name).to appear_before(top_customers[1].last_name)
          expect(top_customers[1].last_name).to appear_before(top_customers[2].last_name)
          expect(top_customers[2].last_name).to appear_before(top_customers[3].last_name)
          expect(top_customers[3].last_name).to appear_before(top_customers[4].last_name)
        end
      end

      it "does not include failed transactions with my merchant" do
        not_top = create(:customer, :with_transactions, successful: 1, failed: 7, merchant: merchant)

        visit dashboard_merchant_path(merchant)

        expect(page).not_to have_content("#{not_top.first_name} #{not_top.last_name}")
      end

      it "does not include successful transactions with other merchants" do
        not_top = create(:customer, :with_transactions, successful: 7)

        visit dashboard_merchant_path(merchant)

        expect(page).not_to have_content("#{not_top.first_name} #{not_top.last_name}")
      end
    end

    describe 'items ready to ship' do
      let!(:ready_to_ship) {create_list(:item, 4, :with_status, status: "packaged", merchant: merchant)}

      it 'displays items with invoice_item status pending' do
        pending_item = create(:item, :with_status, status: "pending", merchant: merchant)
        shipped_item = create(:item, :with_status, status: "shipped", merchant: merchant)
        unordered_item = create(:item, merchant: merchant)

        visit dashboard_merchant_path(merchant)

        within "#items_to_ship" do
          expect(page).to have_content("Items Ready to Ship")
          ready_to_ship.each do |item|
            within("#item-#{item.id}")
              expect(page).to have_content(item.name)
              invoice = item.invoices[0]
              expect(page).to have_link("Invoice ##{invoice.id}",
                href: merchant_invoice_path(merchant.id, invoice.id))
              expect(page).to have_content(invoice.created_at.strftime("%A, %B %-d, %Y"))
            end
          expect(page).not_to have_content(pending_item.name)
          expect(page).not_to have_content(shipped_item.name)
          expect(page).not_to have_content(unordered_item.name)
        end
      end

      it 'does not display items of other merchants' do
        item = create(:item)

        visit dashboard_merchant_path(merchant)

        expect(page).not_to have_content(item.name)
      end

      it 'displays items ordered by invoice creation date' do
        visit dashboard_merchant_path(merchant)

        invoices = Invoice.order(:created_at)
        expect("Invoice ##{invoices[0].id}").to appear_before("Invoice ##{invoices[1].id}")
        expect("Invoice ##{invoices[1].id}").to appear_before("Invoice ##{invoices[2].id}")
        expect("Invoice ##{invoices[2].id}").to appear_before("Invoice ##{invoices[3].id}")
      end
    end
  end
end
