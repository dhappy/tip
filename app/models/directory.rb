require 'net/http'

class Directory < Entry
  has_and_belongs_to_many :references, join_table: :directories_references
  has_many :entries, through: :references
  
  def percent_complete
    count = link_count
    if count[:total] == 0
      '100%'
    else
      "#{((count[:whole].to_f / (count[:total].nonzero? || 1)) * 100).round}%"
    end
  end

  def link_count
    @link_count ||= {}.tap do |count|
      count[:total] = count[:whole] = 0
      unseen = entries.to_a
      seen = []
      while unseen.any?
        candidate = unseen.pop
        if candidate.kind_of?(Directory)
          unseen += candidate.entries.select do |entry|
            !seen.include?(entry) &&
              (entry.kind_of?(Link) || entry.kind_of?(Directory))
          end
        end
        if candidate.kind_of?(Link)
          count[:total] += 1
          if candidate.whole?
            count[:whole] += 1
          end
        end
        seen << candidate
      end
    end
  end
end
