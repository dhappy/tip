require 'net/http'

class Space < ActiveRecord::Base
  has_and_belongs_to_many :entries

  # A hash may be:
  #  * a directory
  #  * a json array of hashes (ToDo: namespaced xml)
  #  * a link
  #  * another file
  #  * dereferencable
  def lookup(hash)
    entry = Entry.find_by(code: hash) # ToDo: collisions

    Entry.ls(hash)
    
    return entry if entry
    
    query = "#{@host}:#{@port}/api/v0/block/get?arg=#{hash}"
    ret = Net::HTTP.get(URI.parse(query))
    
    FileMagic.open(:mime) { |fm| puts fm.buffer(ret) }
    
    if ret.length > 6 && ret[0..1] == "\n\u0010" # symlink?
      dest = ret[6..-1].force_encoding('utf-8')
      
      entry = Link.find_or_create_by({
                                       code: hash,
                                       destination: dest
                                     })
    else
      entry = Blob.find_or_create_by(code: hash)
    end
  
    self.entries += [entry]
  
    if entry.mime.types.include?('text/xml+conglom')
      data = JSON.parse(entry.content)
      
      entry = Conglomeration.new(hash)
        
      data.each do |str| # This is terribly dangerous
        entry.entries += lookup(str, dir)
      end
    end
    
    entry.save
    
    entry
  end
end
