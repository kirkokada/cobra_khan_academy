ActiveAdmin.register Instructional do
  permit_params :url, :title, :description
  belongs_to :topic

  form do |f|
    f.semantic_errors
    inputs do
      input :title
      input :url
      input :description
      input :topic, as: "hidden"
    end
    actions
  end
end
