ActiveAdmin.register Topic do
  permit_params :ancestry, :description, :name
  menu priority: 8

  active_admin_importable

  sortable tree: true,
           sorting_attribute: :ancestry,
           parent_method: :parent,
           children_method: :children,
           roots_method: :roots,
           collapsible: true

  index as: :sortable do
    label :name
    actions do |topic|
      links = ""
      links << link_to("New Child", 
                       new_admin_child_topic_path(topic), 
                       class: "member_link")
      links << link_to("New Instructional", 
                        new_admin_topic_instructional_path(topic), 
                        class: "member_link")
      links.html_safe
    end
  end

  index as: :table

  action_item :new_instructional, only: :show do
    link_to "New Instructional", new_admin_topic_instructional_path(topic)
  end

  show do
    panel "Instructionals" do
      table_for topic.instructionals do 
        column :title
        column :url
        column(:actions) do |instructional|
          links = ""
          links << link_to("Edit", 
                           edit_admin_topic_instructional_path(topic, instructional), 
                           class: "member_link")
          links << link_to("Delete", 
                           admin_topic_instructional_path(topic, instructional), 
                           class: "member_link",
                           method: :delete)
          links.html_safe
        end
      end
    end
    active_admin_comments
  end

  sidebar "Topic Details", only: [:show, :edit] do
    attributes_table_for topic do
      row :id
      row :name
      row :description
      row :ancestry
      row :slug
      row :created_at
      row :updated_at
    end
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
      if parent = Topic.find_by(slug: params[:id])
        @topic = parent.children.build()
      else
        @topic = Topic.new
      end
    end
  end
end
