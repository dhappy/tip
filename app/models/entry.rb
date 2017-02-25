require 'ostruct'
require 'deepstruct'
require 'pry'

class Entry < ActiveRecord::Base
  has_and_belongs_to_many :spaces
  has_and_belongs_to_many(
    :parents,
    class_name: 'Entry',
    join_table: 'directories_entries',
    association_foreign_key: 'directory_id'
  )

  @base_find_or_create_by = self.method(:find_or_create_by)
  
  def self.find_or_create_by(args)
    if args.length == 1 && args[:code]
      entry = find_by(args)
      
      if !entry
        listing = ls(args[:code])
        links = listing[:Objects].collect{ |o| o[:Links] }.flatten
        
        if links
          entry = Directory.create({ code: hash })
          
          entry.references += links.map do |link|
            Reference.find_or_create_by(
              {
                name: link[:Name],
                entry: Entry.find_or_create_by(
                  {
                    code: link[:Hash],
                    type: @types[link[:Type]]
                  }
                )
              }
            )
          end
        else
          logger.info("Unhandled Hash Return: #{hash}")
        end
      end
    end
    
    entry = @base_find_or_create_by.call(args) if not entry

    entry
  end
  
  def mime
    OpenStruct.new({
      types: []
    })
  end

  def self.ls(hash)
    config = Rails.application.config.tip.ipfs
    query = "#{config.host}:#{config.port}/api/v0/ls" +
            "?arg=#{hash}&headers=true&resolve-type=true"
    JSON.parse(Net::HTTP.get(URI.parse(query)), symbolize_names: true)
  end
end

module CreateEntry
  def self.included base
    base_find_or_create_by = base.method(:find_or_create_by)
    
    base.define_singleton_method(:find_or_create_by) do
      if args.length == 1 && args[:code]
        binding.pry
      end
      base_find_or_create_by.call(args)
    end
  end
end

#Entry.send(:include, CreateEntry)
