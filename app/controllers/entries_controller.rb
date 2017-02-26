class EntriesController < ApplicationController
  def initialize(*args)
    @space = Space.create()
  end

  def index
    @entries = Entry.all
  end

  def show
    id =  params[:id]

    if id.start_with?('.../')
      @entry = lookup(id)
    else
      @hash = id
      @entry = Entry.find_or_create_by(code: @hash)
    end
      
    if @entry.kind_of?(Blob)
      send_data @entry.content, type: 'text/html', disposition: 'inline'
    end
  end

  def lookup(path)
    dirs = Directory.all - Directory.joins(:references)
    binding.pry
  end
end
