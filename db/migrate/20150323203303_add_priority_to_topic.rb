class AddPriorityToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :priority, :integer, default: 1
  end
end
