class AddIndexForProgrammeId < ActiveRecord::Migration[6.0]
  def change
    add_index :activity_objectives, :programme_id
  end
end
