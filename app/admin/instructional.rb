ActiveAdmin.register Instructional do
  permit_params :url, :title, :description
  belongs_to :topic, optional: true
  menu priority: 9
  
  # Displays topic filter using slugs sorted alphabetically as select options
  filter :topic, as: :select, collection: Topic.pluck(:slug, :id).sort_by{ |a| a[0] }
  filter :title

  batch_action :set_topic_for, form: -> {{topic: Topic.pluck(:slug, :id).sort_by{ |a| a[0] }}} do |ids, inputs|
    topic = Topic.find(inputs[:topic])
    ids.each { |id| Instructional.find(id).update_column(:topic_id, topic.id) }
    redirect_to collection_path, notice: "Instructional updated"
  end

  index do
    selectable_column
    column :title
    column "Description" do |instructional|
      truncate(instructional.description, omission: "...", length: 150)
    end
    column "Topic" do |instructional|
      instructional.topic.name_with_ancestry
    end
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    inputs do
      input :topic, as: :select, collection: Topic.pluck(:slug, :id).sort_by{ |a| a[0] }
      input :url
    end
    actions
  end
end
