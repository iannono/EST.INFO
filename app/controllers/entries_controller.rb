class EntriesController < ApplicationController
  def index
    @q = params[:q].present? ? Entry.search(params[:q]) : Entry.search
    @entries = @q.result
    @entries = @entries.page params[:page]
  end

  def show
    @entry = Entry.find(params[:id])
  end
end
