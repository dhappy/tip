require 'net/http'

class Directory < Entry
  has_and_belongs_to_many :references, join_table: :directories_references
  has_many :entries, through: :references
  
  def self.find_or_create_by(opts)
    find_by(opts) && return
    
    listing = Entry.ls(opts[:code])
    links = listing[:Objects].collect{ |o| o[:Links] }.flatten

    Directory.create(opts).tap do |this|
      this.references << links.map do |link|
        Reference.find_or_create_by(
          {
            name: link[:Name],
            entry: Entry.types[link[:Type]].constantize.find_or_create_by(
              { code: link[:Hash] }
            )
          }
        )
      end
    end
  end

  def percent_complete
    if link_count[:whole] == 0
      "No Links"
    else
      link_count[:whole] / (link_count[:total].nonzero? || 1)
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
          unseen << candidate.entries.select do |entry|
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
      end
    end
  end
end
