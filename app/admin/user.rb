ActiveAdmin.register User do
  menu :priority => 3
  config.sort_order = "id_desc"
  permit_params :email

end
