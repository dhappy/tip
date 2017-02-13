class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|

      t.timestamps null: false
    end
  end
end
