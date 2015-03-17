class AddSlugToInstructionals < ActiveRecord::Migration
  def change
    add_column :instructionals, :slug, :string
    add_index :instructionals, :slug
  end
end
