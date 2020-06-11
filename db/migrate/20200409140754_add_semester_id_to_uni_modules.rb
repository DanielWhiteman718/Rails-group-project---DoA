class AddSemesterIdToUniModules < ActiveRecord::Migration[6.0]
  def change
    remove_column :activities, :semester_id
    add_column :uni_modules, :semester_id, :bigint
  end
end
