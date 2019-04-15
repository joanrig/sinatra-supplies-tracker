class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.string :vendor
      t.string :website
      t.string :unit_type
      t.decimal :price_per_unit
    end
  end
end
