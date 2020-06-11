class AddIndexToActivities < ActiveRecord::Migration[6.0]
  def change
    add_index :activities, [:theme_id, :code, :uni_module_id], unique: true
  end
end
