require "rails_helper"

RSpec.describe "Merchant Invoices show" do
  describe "Displays" do
    it "invoices that have merchant's items" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      invoice = create(:invoice, merchant: merchant1)
      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content(invoice.id)
      expect(page).to have_content(invoice.created_at.strftime("%A, %B %-d, %Y"))
      expect(page).to have_content(invoice.status)
    end

    it "customer info" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content("Linda Mayhew")
      expect(page).to have_content(customer.address)
    end

    it "invoice item information and discounts" do
      merchant1 = create(:merchant)
      discount1 = create(:bulk_discount, merchant: merchant1, percent_off: 50, item_quantity: 3)
      discount2 = create(:bulk_discount, merchant: merchant1, percent_off: 100, item_quantity: 10000)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)
      invoice_items = []
      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items[0..2].each do |item|
        invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 10, unit_price: 1, bulk_discount_id: discount1.id)
      end

      items[3..4].each do |item|
        invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 1, unit_price: 1, bulk_discount_id: nil)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      within "#item-information" do

        InvoiceItem.all.each do |invoice_item|
          expect(page).to have_content(invoice_item.item.name)
          expect(page).to have_content("quantity: #{invoice_item.quantity}")
          expect(page).to have_content("unit price: #{invoice_item.unit_price}")
        end
      end
      invoice_items[0..2].each do |invoice_item|
        within("#item-#{invoice_item.id}") do
          click_on "See Discount"
          expect(current_path).to eq(merchant_bulk_discount_path(merchant1.id, discount1.id))
          visit merchant_invoice_path(merchant1, invoice)
        end
      end

      invoice_items[3..4].each do |invoice_item|
        within("#item-#{invoice_item.id}") do
          expect(page).to have_no_content("See Discount")
        end
      end
    end

    it "can alter invoice_item status" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      within "#item-information" do
        InvoiceItem.all.each do |invoice_item|
          within "#status-#{invoice_item.id}" do
            expect(page).to have_button("Update Item Status!")
            expect(page).to have_select("invoice_item[status]", selected: "#{invoice_item.status}")
            if invoice_item.status == "pending"
              select("packaged", from: "invoice_item[status]")
              click_button "Update Item Status!"
              expect(page).to have_select("invoice_item[status]", selected: "packaged")
            else
              select("pending", from: "invoice_item[status]")
              click_button "Update Item Status!"
              expect(page).to have_select("invoice_item[status]", selected: "pending")
            end
          end
        end
      end
    end
    it "total revenue" do
      merchant1 = create(:merchant)

      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content("Total Revenue: $#{invoice.invoice_amount}")
    end

    it "total revenue with a discount" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)
      discount = create(:bulk_discount, merchant: merchant1, percent_off: 50, item_quantity: 0)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1, percent_paid: 50)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content("Total Revenue: $#{invoice.invoice_amount}")
    end
  end
end
