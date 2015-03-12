ActiveAdmin.register Topic do
  permit_params :parent_id, :description, :name
end
