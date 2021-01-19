class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, foreign_key: true
      t.integer :item_quantity
      t.integer :percent_off
      t.timestamps
    end
  end
end
