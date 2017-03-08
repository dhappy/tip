require 'net/http'

class Space < ActiveRecord::Base
  has_and_belongs_to_many :roots, uniq: true, class_name: 'Entry'

  def lookup(name)
    parts = name.split(/\//)

    candidates = entries

    while !candidates.empty? && !parts.empty?
      part = parts.shift
      candidates = candidates.map do |candidate|
        if candidate.kind_of?(Directory)
          if ref = candidate.references.find{ |ref| ref.name == part }
            ref.entry
          end
        end
      end
      candidates.compact!
    end

    candidates.first
  end
end
