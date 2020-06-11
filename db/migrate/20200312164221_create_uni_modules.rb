class CreateUniModules < ActiveRecord::Migration[6.0]
  def change
    create_table :uni_modules do |t|
      t.string :code, :null => false, :unique => true
      t.integer :level, :null=> false

      t.timestamps
    end
  end
end
