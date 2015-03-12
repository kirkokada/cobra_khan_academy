class AddAncestryToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :ancestry, :string
    remove_column :topics, :parent_id
    add_index :topics, :ancestry
  end
end
