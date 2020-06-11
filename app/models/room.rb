# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ApplicationRecord

    audited
    
    # Model for a room, had a code (room number in diamond) and a name

    # Preferred room links to activities by pre_room field
    has_many :activity_timetables, through: :room_bookings
    has_many :activity_timetables, class_name: 'ActivityTimetable', foreign_key: 'pref_room_id'

    # Other rooms link to activities by a RoomBooking object
    has_many :room_bookings

    validates :code, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true

    def display_str
        "#{name} (#{code})"
    end

end
