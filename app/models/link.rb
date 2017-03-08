require 'net/http'

class Link < Directory
  def references
    if super.empty?
      binding.pry
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

  def complete?
    references.any?
  end
end
