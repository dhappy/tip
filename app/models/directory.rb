class Directory < Entry
  has_and_belongs_to_many(:entries, join_table: 'directories_entries') do
=begin
    def +(entries)
      super
      entries.each { |entry| entry.parents += [self] }
    end
=end
  end
end
