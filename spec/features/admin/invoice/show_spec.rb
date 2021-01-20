require 'rails_helper'

RSpec.describe "admin invoices show page" do
  before :each do
    @invoice = FactoryBot.create(:invoice)
    FactoryBot.create_list(:invoice_item, 4, invoice_id: @invoice.id )
    visit admin_invoice_path(@invoice.id)
  end

  it "displays revenue calculated using discounts" do
    merchant1 = create(:merchant)
    discount1 = create(:bulk_discount, merchant: merchant1, percent_off: 50, item_quantity: 3)
    discount2 = create(:bulk_discount, merchant: merchant1, percent_off: 100, item_quantity: 10000)
    items = create_list(:item, 5, merchant: merchant1, unit_price: 1)
    invoice_items = []
    customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

    invoice = create(:invoice, merchant: merchant1, customer: customer)

    items[0..2].each do |item|
      invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 10, unit_price: 10, bulk_discount_id: discount1.id)
    end

    items[3..4].each do |item|
      invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 1, unit_price: 10, bulk_discount_id: nil)
    end

    visit admin_invoice_path(invoice.id)
    within("#invoice-revenue") do
      expect(page).to have_content("Total Revenue: $#{invoice.invoice_items.invoice_amount}")
    end
  end

  it "displays information related to current invoice" do
    within("#invoice-information") do
      expect(page).to have_content(@invoice.id)
      expect(page).to have_content(@invoice.status)
      expect(page).to have_content(@invoice.created_at.strftime("%A, %B %d, %Y"))
    end
  end

  it "displays customer information related to current invoice" do
    within("#customer-information") do
      expect(page).to have_content(@invoice.customer.first_name)
      expect(page).to have_content(@invoice.customer.last_name)
      expect(page).to have_content(@invoice.customer.address)
    end
  end

  it "displays items' information related to invoice" do
    within("#invoice-items-information") do
      @invoice.invoice_items.each do |ii|
        within("#invoice-item-#{ii.id}") do
          expect(page).to have_content(ii.item.name)
          expect(page).to have_content(ii.quantity)
          expect(page).to have_content(ii.unit_price)
          expect(page).to have_content(ii.status)
        end
      end
    end
  end

  it "displays total revenue of the current invoice" do
    within("#invoice-information") do
      expect(page).to have_content(@invoice.invoice_items.invoice_amount)
    end
  end

  describe "admin invoice status link" do
    it "has a select field for status with the current status selected" do
      within("#invoice-information") do
        expect(page).to have_selector(:id, 'status', text: @invoice.status)
      end
    end
    it "can select a new status and update the status" do
      merchant1 = create(:merchant)
      discount1 = create(:bulk_discount, merchant: merchant1, percent_off: 100, item_quantity: 5)
      discount2 = create(:bulk_discount, merchant: merchant1, percent_off: 50, item_quantity: 1)
      discount3 = create(:bulk_discount, merchant: merchant1, percent_off: 50, item_quantity: 1) #this will never be applied
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)
      invoice_items = []
      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items[0..2].each do |item| #these are not set manually, so these items having a discount means it was done automatically.
        invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 10, unit_price: 10, bulk_discount_id: nil)
      end

      items[3..4].each do |item|
        invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 2, unit_price: 10, bulk_discount_id: nil)
      end

      visit(admin_invoice_path(invoice.id))

      within("#invoice-information") do
        expect(page).to have_select('status', selected: invoice.status, options: ['in progress', 'completed', 'cancelled'])
        page.select('cancelled', from: 'status')
        click_on 'Save'

        expect(current_path).to eq(admin_invoice_path(invoice.id))
        expect(page).to have_content('completed')

        page.select('completed', from: 'status') #setting to completed finalizes discounts
        click_on 'Save'

        invoice_items.each do |async_invoice_item|
          invoice_item = InvoiceItem.find(async_invoice_item.id)
          expect(invoice_item.bulk_discount_id).to eq(invoice_item.best_discount.id)
        end
      end
    end
  end

end
