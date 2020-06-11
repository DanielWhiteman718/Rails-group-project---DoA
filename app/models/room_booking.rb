# == Schema Information
#
# Table name: room_bookings
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  activity_timetable_id :bigint           not null
#  room_id               :bigint           not null
#
# Indexes
#
#  index_room_bookings_on_activity_timetable_id  (activity_timetable_id)
#  index_room_bookings_on_room_id                (room_id)
#

class RoomBooking < ApplicationRecord

    audited
    audited associated_with: :activity_timetable
    
    # Model which records which room an activity will use

    # Links a room and an activity_timetable object together
    belongs_to :room
    belongs_to :activity_timetable

    # Activity and room must both be filled in
    validates :activity_timetable, presence: true
    validates :room, presence: true

end
