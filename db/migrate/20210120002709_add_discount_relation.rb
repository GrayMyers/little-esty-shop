class AddDiscountRelation < ActiveRecord::Migration[5.2]
  def change
    change_table :invoice_items do |t|
      t.references :bulk_discount, foreign_key: true
      t.integer :percent_paid, default: 100
    end
  end
end
