class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories_entries do |t|
      t.integer :directory_id
      t.integer :entry_id
    end
  end
end
