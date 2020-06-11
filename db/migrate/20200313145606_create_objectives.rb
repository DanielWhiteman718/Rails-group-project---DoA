class CreateObjectives < ActiveRecord::Migration[6.0]
  def change
    create_table :objectives do |t|
      t.string :code, :null => false, :unique => true
      t.string :name, :null => false

      t.timestamps
    end
  end
end
