class AddImageNameToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :img_name, :string
  end
end
