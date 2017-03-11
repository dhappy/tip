require 'net/http'

class Link < Directory
  def references
    if super.empty?
      if dest = @@space.lookup(destination)
        super << Reference.find_or_create_by(
          {
            name: destination,
            entry: dest
          }
        )
      end
    end
    super
  end

  def whole?
    references.any?
  end

  def resolves?
    references.any?
  end
  
  def destination
    if not super
      config = Rails.application.config.tip.ipfs
      query = "#{config.host}:#{config.port}/api/v0/block/get?arg=#{code}"
      ret = Net::HTTP.get(URI.parse(query))

      dest = ret[6..-1].force_encoding('utf-8')
      self.update_attribute(:destination, dest)
    end
    super
  end
end
