FactoryBot.define do
  factory :invoice_item, class: InvoiceItem do
    association :item
    association :invoice
    association :bulk_discount
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Number.between(from: 1, to: 100) }
    status {["pending", "packaged", "shipped"].sample}


    trait :sequenced do
      sequence :quantity
    end
  end
end
