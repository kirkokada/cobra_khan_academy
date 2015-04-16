class AddForeignKeyToInstructionals < ActiveRecord::Migration
  def change
    add_foreign_key :instructionals, :topics, dependent: :delete
  end
end
