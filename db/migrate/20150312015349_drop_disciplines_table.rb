class DropDisciplinesTable < ActiveRecord::Migration
  def up
    drop_table :disciplines
  end

  def down
    create_table :disciplines
  end
end
