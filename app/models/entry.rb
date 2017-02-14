class Entry < ActiveRecord::Base
  has_and_belongs_to_many :spaces
  has_and_belongs_to_many(
    :parents,
    class_name: 'Entry',
    join_table: 'directories_entries',
    association_foreign_key: 'directory_id'
  )

  serialize :names, Array
end
