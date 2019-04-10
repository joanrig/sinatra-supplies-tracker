class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :type
      t.date :date
      t.integer :attendees
      t.decimal :supplies_budget
    end
  end
end
