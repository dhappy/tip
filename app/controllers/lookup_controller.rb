require 'ipfs/client'

class LookupController < ApplicationController
  def initialize
    @space = Space.new
  end
  
  def root
  end

  def hash
    @hash = params[:hash]
    @entry = Entry.ls(@hash)
    @entry = Entry.find_or_create_by(code: @hash)
  end
end
