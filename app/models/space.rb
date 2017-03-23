require 'net/http'

class Space < ActiveRecord::Base
  has_and_belongs_to_many :roots, uniq: true, class_name: 'Entry'

  def lookup(name)
    parts = name.split(/\//)

    candidates = roots

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

    if candidates.first.kind_of?(Directory)
      Directory.new().tap do |dir|
        candidates.reverse.each do |candidate|
          dir.references += candidate.references if candidate.kind_of?(Directory)
        end
      end
    else
      candidates.first
    end
  end
end
