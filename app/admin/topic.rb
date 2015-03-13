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

  controller do
    def new
      @topic = Topic.new(ancestry: params[:id])
    end
  end
end
