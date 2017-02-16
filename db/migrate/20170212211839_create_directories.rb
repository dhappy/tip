class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :name
      t.references :entry, index: true
      
      t.timestamps null: false
    end
    add_foreign_key :references, :entries

    create_join_table :directories, :references
  end
end
