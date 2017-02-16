class Directory < Entry
  has_and_belongs_to_many :references, join_table: :directories_references
end
