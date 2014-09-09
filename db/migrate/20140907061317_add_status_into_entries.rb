class AddStatusIntoEntries < ActiveRecord::Migration
  def change
    add_column :entries, :status, :integer, default: 0
    remove_column :entries, :uploaded
  end
end
