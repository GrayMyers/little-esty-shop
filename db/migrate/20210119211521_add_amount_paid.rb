class AddAmountPaid < ActiveRecord::Migration[5.2]
  def change
    drop_table :discount_items
  end
end
