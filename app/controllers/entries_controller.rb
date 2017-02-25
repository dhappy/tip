class EntriesController < ApplicationController
  def index
    @entries = Entry.all
  end

  def show
    id =  params[:id]

    if id.start_with('.../')
      current_user.space.lookup(id)
    else
      @hash = id
      @entry = Entry.find_or_create_by(code: @hash)
      
      if @entry.kind_of?(Blob)
        send_data @entry.content, type: 'text/html', disposition: 'inline'
      end
    end
  end
end
