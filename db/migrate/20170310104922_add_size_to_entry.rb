class AddSizeToEntry < ActiveRecord::Migration
  def change
    change_table :entries do |t|
      t.integer :size
    end
  end
end
