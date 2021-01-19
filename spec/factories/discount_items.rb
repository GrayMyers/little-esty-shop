FactoryBot.define do
  factory :discount_item, class: DiscountItem do
    association :invoice_item
    association :bulk_discount
    item_quantity { Faker::Number.between(from: 1, to: 10) }
    percent_off { Faker::Number.between(from: 1, to: 100) }
  end
end
