require 'ostruct'
require 'deepstruct'
require 'pry'

class Entry < ActiveRecord::Base
  has_and_belongs_to_many :spaces
  has_many :parents, class_name: 'Reference'

  @@space = Space.first_or_create()
  
  def self.types
    %w{DNE Directory Blob Ukn Link}
  end
  
  def self.find_or_create_by(args)
    entry = find_by(args)
      
    if !entry
      listing = ls(args[:code])
      links = listing[:Objects].collect{ |o| o[:Links] }.flatten
      
      if links.any?
        entry = Directory.create(args)
        entry.references << links.map do |link|
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
  
    entry || super
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
