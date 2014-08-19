ActiveAdmin.register DelayedJob do
  menu :priority => 12
  actions :all, except: [:new, :create, :edit, :update]
  config.sort_order = "id_desc"

  index do
    selectable_column
    column :priority
    column :attempts
    column :handler
    column :last_error
    column :queue
    column :run_at
    column :created_at
    actions
  end
end
