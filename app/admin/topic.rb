ActiveAdmin.register Topic do
  permit_params :parent, :parent_id, :description, :name, :priority, :ancestry, :id
  menu priority: 8

  sortable tree: true,
           sorting_attribute: :position,
           parent_method: :parent,
           children_method: :subtopics_by_priority,
           roots_method: :roots,
           collapsible: true

  index as: :sortable do
    label :name
    actions do |topic|
      links = ""
      links << link_to("New Subtopic", 
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

  action_item :import_topics, only: :index do
    link_to "Import CSV", new_admin_csv_importer_path(model_name: "Topic")
  end

  collection_action :upload, method: :get do
    @csv_importer = CSVImporter.new(model_name: "Topic")
  end

  collection_action :import, method: :post do
    @csv_importer = CSVImporter.new(params[:csv_importer])
    if @csv_importer.save
      flash[:notice] = "CSV imported successfully."
      redirect_to action: :index
    else
      render :upload
    end
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
      row :priority
      row :slug
      row :created_at
      row :updated_at
    end
    ul do
      li link_to "Instructionals", admin_topic_instructionals_path(topic)
    end
  end

  form do |f|
    f.semantic_errors
    inputs do
      input :name
      input :description
      input :priority
      input :parent_id, as: :select, collection:  Topic.pluck(:slug, :id).sort_by{ |a| a[0] }, include_blank: true
    end
    actions
  end

  controller do
    def new
      if parent = Topic.find_by(slug: params[:id])
        @topic = Topic.new(parent_id: parent.id)
      else
        @topic = Topic.new
      end
    end
  end

  csv do
    column :id
    column :name
    column :description
    column(:parent_id) { |topic| topic.parent ? topic.parent.id : nil }
  end
end
