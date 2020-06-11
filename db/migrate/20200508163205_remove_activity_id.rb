class RemoveActivityId < ActiveRecord::Migration[6.0]
  def change
    remove_column :activity_objectives, :activity_id
  end
end
