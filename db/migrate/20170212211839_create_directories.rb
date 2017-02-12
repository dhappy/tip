class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.integer :entries, array: true, default: []

      t.timestamps null: false
    end
  end
end
