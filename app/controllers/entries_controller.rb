class EntriesController < ApplicationController
  def initialize(*args)
    @space = Space.first_or_create()
  end

  def index
    @entries = @space.entries
  end

  def show
    id =  params[:id]

    if id.start_with?('.../')
      @entry = @space.lookup(id)
    else
      @hash = id
      @entry = Entry.find_or_create_by(code: @hash)

      if @entry.parents.empty? && !@space.entries.include?(@entry)
        @space.entries << @entry
      end
    end
      
    if @entry.kind_of?(Blob)
      send_data @entry.content, type: 'text/html', disposition: 'inline'
    end
  end
end
