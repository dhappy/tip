require 'net/http'

class Link < Entry
  def destination
    if not super
      config = Rails.application.config.tip.ipfs
      query = "#{config.host}:#{config.port}/api/v0/block/get?arg=#{code}"
      ret = Net::HTTP.get(URI.parse(query))
    
      if ret.length > 6 && ret[0..1] == "\n\u0010" # symlink?
        self.destination = ret[6..-1].force_encoding('utf-8')
      else
        raise "Not a link"
      end
    end
    super
  end
end
