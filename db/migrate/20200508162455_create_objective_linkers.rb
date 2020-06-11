class CreateObjectiveLinkers < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_linkers do |t|
      t.belongs_to :activity
      t.belongs_to :activity_objective
      t.timestamps
    end
  end
end
