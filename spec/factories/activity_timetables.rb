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

FactoryBot.define do
  factory :activity_timetable do
    capacity {30}
    checked_on_timetable {true}
    duration {90}
    kit_prep_time {30}
    max_week_num {37}
    min_week_num {2}
    notes {"Timetabling notes blah blah"}
    same_as_prev_year {false}
    series_setup_time {15}
    setup_time {30}
    takedown_time {20}
  end
end
