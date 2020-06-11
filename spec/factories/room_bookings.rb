
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

FactoryBot.define do
    factory :room_booking do
      
    end
  end