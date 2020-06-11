class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.belongs_to :theme, :null => false
      t.string :code, :null => false
      t.belongs_to :uni_module, :null => false
      t.string :name, :null => false
      t.boolean :archived, :null => false
      t.text :notes
      t.boolean :in_drive, :null => false

      t.timestamps
    end
  end
end
