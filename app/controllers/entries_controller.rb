class EntriesController < ApplicationController
  def index
    @entries = Entry.page params[:page]
  end

  def show
    @entry = Entry.find(params[:id])
    if @entry
      render json: {result: true, content: @entry.full_content, link: @entry.product}
    else
      render json: {result: false}
    end
  end
end
