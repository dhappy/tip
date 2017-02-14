class Directory < Entry
  has_and_belongs_to_many :entries, join_table: 'directories_entries'
end
