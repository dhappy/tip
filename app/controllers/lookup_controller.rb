require 'ipfs/client'

class LookupController < ApplicationController
  def initialize
    @space = Space.new
  end
  
  def root
  end

  def hash
    @hash = params[:hash]
    @entry = @space.lookup(@hash)
  end

  protected
end
