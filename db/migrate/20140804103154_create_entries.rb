class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.string :content
      t.string :img
      t.string :product
      t.string :user
      t.datetime :happend_at
      t.string :price
      t.string :city
      t.string :source

      t.timestamps
    end
  end
end
