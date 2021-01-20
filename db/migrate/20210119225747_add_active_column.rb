class AddActiveColumn < ActiveRecord::Migration[5.2]
  def change
    change_table :bulk_discounts do |t|
      t.boolean :active, default: true
    end
  end
end
