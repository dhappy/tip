require 'ipfs/client'

class Space < ActiveRecord::Base
  has_and_belongs_to_many :entries

  def initialize
    super

    @host, @port = 'http://ipfs.io', 80
    #@host, @port = 'http://localhost', 5001

    @cli = IPFS::Client.new host: @host, port: @port
  end

  # A hash may be:
  #  * a directory
  #  * a json array of hashes (ToDo: namespaced xml)
  #  * a link
  #  * another file
  #  * dereferencable
  def lookup(hash, dir = nil, name = nil)
    entry = Entry.find_by(code: hash) # ToDo: collisions

    res = @cli.ls(hash)

    links = res.collect(&:links).flatten

    if links.any? # Directory
      entry = Directory.find_or_create_by(code: hash)

      binding.pry

      return links

      entry.parents += dir

      links.each do |link|
        lookup(link.hashcode, entry, link.name)
      end
    else
      query = "#{@host}:#{@port}/api/v0/block/get?arg=#{entry.hashcode}"
      ret = Net::HTTP.get(URI.parse(query))

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
