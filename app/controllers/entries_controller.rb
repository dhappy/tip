class EntriesController < ApplicationController
  def index
    @entries = Entry.all
  end

  def show
    @hash = params[:id]
    @entry = Entry.find_or_create_by(code: @hash)
  end
end
