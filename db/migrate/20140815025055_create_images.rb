class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :entry_id
      t.string :img_origin_link
      t.string :img_link
      t.string :img_name
      t.string :source

      t.timestamps
    end
  end
end
