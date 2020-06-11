# == Schema Information
#
# Table name: activity_timetables
#
#  id                   :bigint           not null, primary key
#  capacity             :integer
#  checked_on_timetable :boolean          default(FALSE), not null
#  duration             :integer
#  kit_prep_time        :integer
#  max_week_num         :integer
#  min_week_num         :integer
#  notes                :text
#  same_as_prev_year    :boolean          default(FALSE), not null
#  series_setup_time    :integer
#  setup_time           :integer
#  takedown_time        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  activity_id          :bigint           not null
#  pref_room_id         :bigint
#
# Indexes
#
#  index_activity_timetables_on_activity_id   (activity_id)
#  index_activity_timetables_on_pref_room_id  (pref_room_id)
#

class ActivityTimetable < ApplicationRecord

    audited
    has_associated_audits
    
    belongs_to :activity, optional: true

    has_many :room_bookings, dependent: :destroy
    has_many :rooms, through: :room_bookings
    belongs_to :pref_room, class_name: 'Room', foreign_key: 'pref_room_id', optional: true

    validates_with ActivityTimetableValidator

    # Check boolean values are either true or false (presence validator does not work)
    validates :same_as_prev_year, inclusion: {in: [true, false]}
    validates :checked_on_timetable, inclusion: {in: [true, false]}

    # Returns a string comprised of all the display strings for all
    # non-preferred rooms for this activity (see display_str in room.rb)
    def other_room_str
        room_str = ""
        rooms.each do |room|
            room_str << "#{room.display_str}, "
        end
        room_str.delete_suffix(", ")
    end

end
