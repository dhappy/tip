class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.timestamps null: false
    end

    create_table :entries do |t|
      t.string :code
      t.string :type # For Single-Table Inheritance
      
      t.timestamps null: false
    end

    create_join_table :entries, :spaces
  end
end
