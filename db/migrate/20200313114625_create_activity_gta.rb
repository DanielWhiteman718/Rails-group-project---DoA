class CreateActivityGta < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_gta do |t|
      t.belongs_to :activity, :null => false, :unique => true
      t.float :staff_ratio
      t.integer :marking_time
      t.text :job_desc
      t.text :criteria
      t.text :jobshop_desc
      t.timestamps
    end
  end
end
