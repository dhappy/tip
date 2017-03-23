class EntriesController < ApplicationController
  def initialize(*args)
    @space = Space.first_or_create()
    super
  end

  def index
    @entries = @space.roots
  end

  def show
    id = params[:id]

    if id = '...' || id.start_with?('.../')
      @entry = @space.lookup(id)
    else
      @hash = id
      @entry = Entry.find_or_create_by(code: @hash)

      if @entry.parents.empty? && !@space.roots.include?(@entry)
        @space.roots << @entry
      end
    end
      
    if @entry.kind_of?(Blob)
      send_data @entry.content, type: 'text/html', disposition: 'inline'
    end
  end
end
