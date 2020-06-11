class CreateActivityAssesses < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_assesses do |t|
      t.belongs_to :activity, :null => false, :unique => false
      t.integer :num_assess
      t.integer :pre_assess_type
      t.integer :during_assess_type
      t.integer :post_assess_type
      t.integer :post_lab_type
      t.float :assess_weight
      t.text :notes

      t.timestamps
    end
  end
end
