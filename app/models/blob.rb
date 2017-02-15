require 'ipfs/client'

class Blob < Entry
  def initialize(*args)
    super
    @cli = IPFS::Client.new host: @host, port: @port
  end
  
  def content
    @cli.cat(code)
  end
end
