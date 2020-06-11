class RemovePreferredFromRoomBookings < ActiveRecord::Migration[6.0]
  def change
    remove_column :room_bookings, :preferred
  end
end
