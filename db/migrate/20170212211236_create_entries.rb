class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :parents, array: true, default: []
      t.string :names, array: true, default: []
      t.string :code

      t.timestamps null: false
    end
  end
end
