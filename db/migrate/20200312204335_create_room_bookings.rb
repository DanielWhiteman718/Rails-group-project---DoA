class CreateRoomBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :room_bookings do |t|
      t.belongs_to :room, :null => false
      t.belongs_to :activity_timetable, :null => false
      t.boolean :preferred, :null => false

      t.timestamps
    end
  end
end
