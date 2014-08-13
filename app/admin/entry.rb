ActiveAdmin.register Entry do
  menu :priority => 2
  config.sort_order = "id_desc"
  permit_params :name, :content, :img, :product, :user, :happend_at, :price, :city, :source

  index do
    selectable_column
    id_column
    column :source
    column :name
    column :price
    column :city
    column :happend_at
    actions
  end
  filter :name
  filter :source
  filter :price
  filter :city
  filter :happend_at
end
