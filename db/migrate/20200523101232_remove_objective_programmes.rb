class RemoveObjectiveProgrammes < ActiveRecord::Migration[6.0]
  def change
    #drop_table :objective_programmes
    add_column :activity_objectives, :programme_id, :bigint
  end
end
