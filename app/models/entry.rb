class Entry < ActiveRecord::Base
  has_and_belongs_to_many :spaces
  has_and_belongs_to_many :directories, join_table: 'directories_entries'

  serialize :names, Array
end
