class CreateLinks < ActiveRecord::Migration
  def change
    change_table :entries do |t|
      t.string :destination
    end
  end
end
