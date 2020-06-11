class AddCapacityToActivityTimetable < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_timetables, :capacity, :integer
  end
end
