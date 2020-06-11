class CreateActivityObjectives < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_objectives do |t|
      t.belongs_to :activity
      t.belongs_to :objective
      t.string :short_desc
      t.string :long_desc

      t.timestamps
    end
  end
end
