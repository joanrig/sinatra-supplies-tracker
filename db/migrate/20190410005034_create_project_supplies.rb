class CreateProjectSupplies < ActiveRecord::Migration
  def change
    create_table :project_supplies do |t|
      t.integer :project_id
      t.integer :supply_id
    end
  end
end
