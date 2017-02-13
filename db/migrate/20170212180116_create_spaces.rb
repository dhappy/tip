class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.timestamps null: false
    end

    create_table :entries do |t|
      t.string :names, array: true, default: []
      t.string :code

      t.timestamps null: false
    end

    create_join_table :entries, :spaces
  end
end
