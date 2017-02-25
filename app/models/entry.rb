require 'ostruct'
require 'deepstruct'
require 'pry'

class Entry < ActiveRecord::Base
  has_and_belongs_to_many :spaces
  has_many :parents, class_name: 'Reference'

  @base_find_or_create_by = self.method(:find_or_create_by)

  def types
    %w{DNE Directory Blob Ukn Link}
  end
  
  def self.find_or_create_by(args)
    if args.length == 1 && args[:code]
      entry = find_by(args)
      
      if !entry
        listing = ls(args[:code])
        links = listing[:Objects].collect{ |o| o[:Links] }.flatten
        
        if links
          entry = Directory.create({ code: args[:code] })
        else
          logger.info("Unhandled Hash Return: #{args[:code]}")
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
