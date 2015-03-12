class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :parent_id, default: nil
      t.integer :discipline_id, default: nil

      t.timestamps null: false
    end

    add_index :topics, :parent_id
    add_index :topics, :discipline_id
  end
end
