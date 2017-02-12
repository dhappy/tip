class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.array :parents
      t.array :names
      t.string :hash

      t.timestamps null: false
    end
  end
end
