class CreateThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :themes do |t|
      t.string :code, :null => false, :unique => true
      t.belongs_to :user

      t.timestamps
    end
  end
end
