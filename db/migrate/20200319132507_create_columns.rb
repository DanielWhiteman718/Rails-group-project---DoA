class CreateColumns < ActiveRecord::Migration[6.0]
  def change
    create_table :columns do |t|
      t.string :table
      t.string :db_name
      t.string :display_name
    end
  end
end
