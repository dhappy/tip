class AddDirectoriesMounts < ActiveRecord::Migration
  def change
    #create_join_table :directories, :mounts
    create_table :directories_mounts do |t|
      t.references :entry, index: true
    end
  end
end
