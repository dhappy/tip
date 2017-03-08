class GiveEntriesNames < ActiveRecord::Migration
  def change
    change_table :entries do |t|
      t.string :name
    end
  end
end
