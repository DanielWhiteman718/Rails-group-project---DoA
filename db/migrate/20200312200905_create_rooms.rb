class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :code, :null => false, :unique => false
      t.string :name, :null => false, :unique => false

      t.timestamps
    end
  end
end
