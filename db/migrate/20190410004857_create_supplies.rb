class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.string :supplier
      t.string :link
      t.decimal :estimated_price
      t.integer :quantity_needed
    end
  end
end
