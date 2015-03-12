class RemoveDisciplineIdFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :discipline_id
  end
end
