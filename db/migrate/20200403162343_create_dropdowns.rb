class CreateDropdowns < ActiveRecord::Migration[6.0]
  def change
    create_table :dropdowns do |t|
      t.string :drop_down
      t.string :value

      t.timestamps
    end
  end
end
