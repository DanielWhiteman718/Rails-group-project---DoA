class AddIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :activity_timetables, :pref_room_id
    add_index :dropdowns, :value
    add_index :dropdowns, :drop_down
    #add_index :objective_programmes, :activity_objective_id
    add_index :uni_modules, :code
    add_index :uni_modules, :semester_id
  end
end
