class AddMeeLeadToActivities < ActiveRecord::Migration[6.0]
  def change
    remove_column :themes, :user_id
    add_reference :activities, :user, foreign_key: true
  end
end
