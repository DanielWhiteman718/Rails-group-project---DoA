class CreateActivityTeachings < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_teachings do |t|
      t.belongs_to :activity, :null => false, :unique => true
      t.belongs_to :user
      t.string :mole_pub_link
      t.string :g_drive_link
      t.integer :resit_priority

      t.timestamps
    end
  end
end
