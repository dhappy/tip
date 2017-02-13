require 'ipfs/client'

class LookupController < ApplicationController
  def initialize
    @space = Space.new
  end
  
  def root
  end

  def hash
    @hash = params[:hash]
    @links = @entry = @space.lookup(@hash)
  end
end
