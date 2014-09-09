class AddUploadedInEntries < ActiveRecord::Migration
  def change
    add_column :entries, :uploaded, :boolean, default: false
  end
end
