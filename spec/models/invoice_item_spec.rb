require "rails_helper"

describe InvoiceItem, type: :model do
  describe "validations" do
    it {should define_enum_for(:status).with_values ["pending", "packaged", "shipped"] }
  end

  describe "relations" do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  describe "class methods" do
    it "set_discounts" do
      merchant1 = create(:merchant)
      discount1 = create(:bulk_discount, merchant: merchant1, percent_off: 100, item_quantity: 5)
      discount2 = create(:bulk_discount, merchant: merchant1, percent_off: 50, item_quantity: 3)
      discount3 = create(:bulk_discount, merchant: merchant1, percent_off: 50, item_quantity: 2) #this will never be applied
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)
      invoice_items = []
      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, merchant: merchant1, customer: customer)

      items[0..2].each do |item| #these are not set manually, so these items having a discount means it was done automatically.
        invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 10, unit_price: 10, bulk_discount_id: nil)
      end


      invoice_items << create(:invoice_item, item: items[3], invoice: invoice, quantity: 3, unit_price: 10, bulk_discount_id: nil)
      invoice_items << create(:invoice_item, item: items[4], invoice: invoice, quantity: 1, unit_price: 10, bulk_discount_id: nil)

      invoice_items.set_discounts

      invoice_items[0..2].each do |invoice_item|
        expect(invoice_item.bulk_discount_id).to eq(discount1.id)
        expect(invoice_item.percent_paid).to eq(100 - discount1.percent_off)
      end

      expect(invoice_items[3].bulk_discount_id).to eq(discount2.id)
      expect(invoice_items[3].percent_paid).to eq(100 - discount2.percent_off)

      expect(invoice_items[4].bulk_discount_id).to eq(nil)
      expect(invoice_items[4].percent_paid).to eq(100)
    end

    it "invoice_amount" do
      invoice = FactoryBot.create(:invoice)
      ii1 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 3, unit_price: 5) #15
      ii2 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 4, unit_price: 5) #20
      ii3 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 5, unit_price: 5) #25

      expect(invoice.invoice_items.invoice_amount).to eq(15+20+25)

      invoice = FactoryBot.create(:invoice)
      ii1 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 3, unit_price: 50, percent_paid: 50) #75
      ii2 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 4, unit_price: 50, percent_paid: 50) #100
      ii3 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 5, unit_price: 50, percent_paid: 50) #125

      expect(invoice.invoice_items.invoice_amount).to eq(300)
    end
  end

  describe "delegates" do
    it "fine" do
      create(:invoice_item)
      expect(InvoiceItem.first.item.name).to eq(InvoiceItem.first.item_name)
    end
  end
end
