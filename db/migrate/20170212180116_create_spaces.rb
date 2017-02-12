class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.integer :entries, array: true, default: []

      t.timestamps null: false
    end
  end
end
