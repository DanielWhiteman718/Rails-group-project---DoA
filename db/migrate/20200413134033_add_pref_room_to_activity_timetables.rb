class AddPrefRoomToActivityTimetables < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_timetables, :pref_room_id, :bigint
  end
end
