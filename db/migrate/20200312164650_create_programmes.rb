class CreateProgrammes < ActiveRecord::Migration[6.0]
  def change
    create_table :programmes do |t|
      t.belongs_to :uni_module
      t.string :code

      t.timestamps
    end
  end
end
