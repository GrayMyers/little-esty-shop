class CreateDiscountItems < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_items do |t|
      t.references :bulk_discount, foreign_key: true
      t.references :invoice_item, foreign_key: true

      t.integer :item_quantity
      t.integer :percent_off

      t.timestamps
    end

    change_table :invoice_items do |t|
      t.remove :bulk_discount_id
    end
  end
end
