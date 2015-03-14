class CreateInstructionals < ActiveRecord::Migration
  def change
    create_table :instructionals do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :uid
      t.string :author
      t.string :duration
      t.integer :topic_id

      t.timestamps null: false
    end

    add_index :instructionals, :uid
  end
end
