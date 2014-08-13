class EntriesController < ApplicationController
  def index
    @entries = Entry.page params[:page]
  end
end
