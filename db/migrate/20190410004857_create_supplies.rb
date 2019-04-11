class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.string :supplier
      t.string :supplier_link
      t.string :unit_type
      t.decimal :price_per_unit
      t.integer :units_needed
      t.integer :project_id
      t.integer :user_id
    end
  end
end
