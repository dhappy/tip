require 'ipfs/client'

class LookupController < ApplicationController
  def initialize
    @host, @port = 'http://ipfs.io', 80
    @host, @port = 'http://localhost', 5001

    @cli = IPFS::Client.new host: @host, port: @port
  end
  
  def root
  end

  def hash
    @hash = params[:hash]

    @links = @cli.ls(@hash).collect(&:links).flatten
    
  end
end
