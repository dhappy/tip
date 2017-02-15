class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :name
      t.integer :entry_id
      
      t.timestamps null: false
    end

    create_table :directories_references do |t|
      t.integer :directory_id
      t.integer :reference_id
    end
  end
end
