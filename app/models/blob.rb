require 'ipfs/client'

class Blob < Entry
  def initialize(*args)
    super
    # Doesn't get called b/c of creation method
  end
  
  def content
    if not @cli
      config = Rails.application.config.tip.ipfs
      @cli = IPFS::Client.new host: config.host, port: config.port
    end
    @cli.cat(code)
  end
end
