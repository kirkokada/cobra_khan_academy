ActiveAdmin.register Topic do
  permit_params :ancestry, :description, :name

  sortable tree: true,
           sorting_attribute: :ancestry,
           parent_method: :parent,
           children_method: :children,
           roots_method: :roots,
           collapsible: true

  index as: :sortable do
    label :name
    actions default: true do |topic|
      link_to "New Child", new_admin_child_topic_path(topic)
    end
  end

  index as: :table do
    column :id
    column :name
    column :ancestry
    actions
  end

  form do |f|
    f.semantic_errors
    inputs do
      input :name
      input :description
      input :ancestry, as: :hidden unless f.object.ancestry.nil?
    end
    actions
  end

  controller do
    def new
      if parent = Topic.find_by_id(params[:id])
        @topic = parent.children.build()
      else
        @topic = Topic.new
      end
    end
  end
end
