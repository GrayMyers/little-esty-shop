FactoryBot.define do
  factory :bulk_discount, class: BulkDiscount do
    association :merchant
    item_quantity { Faker::Number.between(from: 1, to: 10) }
    percent_off { Faker::Number.between(from: 1, to: 100) }
  end
end
