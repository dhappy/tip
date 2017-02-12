require 'ipfs/client'

class LookupController < ApplicationController
  def initialize
    @host, @port = 'http://ipfs.io', 80
    @host, @port = 'http://localhost', 5001

    @source = Source.new

    @cli = IPFS::Client.new host: @host, port: @port
  end
  
  def root
  end

  def hash
    @hash = params[:hash]
    @entry = lookup(@hash)
  end

  protected

  # A hash may be:
  #  * a directory
  #  * a json array of hashes (ToDo: namespaced xml)
  #  * a link
  #  * another file
  #  * dereferencable
  def lookup(hash, dir = nil, name = nil)
    return entry if entry = Entry.find(hash) # ToDo: collisions

    res = @cli.ls(hash)

    links = res.collect(&:links).flatten

    if links.any? # Directory
      entry = Directory.find_or_create(hash)

      entry.parents += dir
      
      links.each do |link|
        lookup(link.hashcode, entry, link.name)
      end
    else
      query = "#{@host}:#{@port}/api/v0/block/get?arg=#{entry.hashcode}"
      ret = Net::HTTP.get(URI.parse(query))
      
      binding.pry

      if ret.length > 6 && ret[0] == 10 # symlink?
        dest = ret[6..-1].force_encoding('utf-8')
        
        entry = Link.find_or_create(dest)
      else
        entry = Blob.find_or_create(hash)
      end
    end
    
    entry.names += name if entry
    dir.entries += entry if dir
    @space.entries += entry 

    if entry.mime.types.include?('application/json')
      data = JSON.parse(entry.content)

      if data.kind_of?(Array)
        strings = data.inject(true) do |string, datum|
          string && datum.kind_of?(String)
        end
        if strings
          entry = Conglomeration.new(hash)

          data.each do |str| # This is terribly dangerous
            entry.entries += lookup(str, dir)
          end
        end
      end
    end
    
    entry
  end
end
