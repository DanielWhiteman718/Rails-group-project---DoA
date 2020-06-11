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

require 'rails_helper'

RSpec.describe ActivityTimetable, type: :model do

  it 'is valid with valid attributes' do
    t = Theme.create(code: 'ACME')
    u = FactoryBot.create(:user, email: 'dperry1@sheffield.ac.uk', display_name: 'Dan Perry')
    s = Dropdown.create(drop_down: 'semester', value: 'Autumn', display_name: 'Semester')
    m = FactoryBot.create(:uni_module, user_id: u.id, semester_id: s.id)
    a = FactoryBot.create(:activity, uni_module_id: m.id, theme_id: t.id)
    r = FactoryBot.create(:room)
    at = FactoryBot.build(:activity_timetable, activity_id: a.id, pref_room_id: r.id)
    expect(at).to be_valid
  end

  it 'is valid with blank attributes' do
    at = ActivityTimetable.new
    expect(at).to be_valid
  end

  it 'is invalid with a duration below 0' do
    at = FactoryBot.build(:activity_timetable)
    # Default duration is 90
    expect(at).to be_valid
    at.duration = 0
    expect(at).to be_valid
    at.duration = -1
    expect(at).to_not be_valid
  end

  it 'is invalid with a setup time below 0' do
    at = FactoryBot.build(:activity_timetable)
    # Default setup time is 30
    expect(at).to be_valid
    at.setup_time = 0
    expect(at).to be_valid
    at.setup_time = -1
    expect(at).to_not be_valid
  end

  it 'is invalid with a series setup time below 0' do
    at = FactoryBot.build(:activity_timetable)
    # Default series setup time is 15
    expect(at).to be_valid
    at.series_setup_time = 0
    expect(at).to be_valid
    at.series_setup_time = -1
    expect(at).to_not be_valid
  end

  it 'is invalid with a kit prep time below 0' do
    at = FactoryBot.build(:activity_timetable)
    # Default kit prep time is 30
    expect(at).to be_valid
    at.kit_prep_time = 0
    expect(at).to be_valid
    at.kit_prep_time = -1
    expect(at).to_not be_valid
  end

  it 'is invalid with a takedown time below 0' do
    at = FactoryBot.build(:activity_timetable)
    # Default takedown time is 20
    expect(at).to be_valid
    at.takedown_time = 0
    expect(at).to be_valid
    at.takedown_time = -1
    expect(at).to_not be_valid
  end

  it 'is valid with a min week number between 1 and 40' do
    at = FactoryBot.build(:activity_timetable, max_week_num: 40)
    at.min_week_num = 1
    expect(at).to be_valid
    at.min_week_num = 0
    expect(at).to_not be_valid
    at.min_week_num = 40
    expect(at).to be_valid
    at.min_week_num = 41
    expect(at).to_not be_valid
  end

  it 'is valid with a max week number between 1 and 40' do
    at = FactoryBot.build(:activity_timetable, min_week_num: 1)
    at.max_week_num = 1
    expect(at).to be_valid
    at.max_week_num = 0
    expect(at).to_not be_valid
    at.max_week_num = 40
    expect(at).to be_valid
    at.max_week_num = 41
    expect(at).to_not be_valid
  end

  it 'is invalid if the max week num is lower than the min week num' do
    at = FactoryBot.build(:activity_timetable, min_week_num: 10, max_week_num: 3)
    expect(at).to_not be_valid
    at.min_week_num = 3
    at.max_week_num = 10
    expect(at).to be_valid
  end

  it 'is invalid with a capacity below 0' do
    at = FactoryBot.build(:activity_timetable)
    # Default capacity is 30
    expect(at).to be_valid
    at.capacity = 0
    expect(at).to be_valid
    at.capacity = -1
    expect(at).to_not be_valid
  end

  describe '#other_room_str' do
    it 'outputs an empty string if the room has no non-preferred rooms' do
      at = ActivityTimetable.new
      allow(at).to receive(:rooms).and_return([])
      expect(at.other_room_str).to eq ""
    end

    it 'outputs the room string of the room it is associated with if it has one room' do
      at = ActivityTimetable.new

      r1 = Room.new(code: '9.09', name: 'made-up room')

      allow(at).to receive(:rooms).and_return([r1])
      expected = r1.display_str
      expect(at.other_room_str).to eq expected
    end

    it 'outputs a comma separated list of all display strings for referenced rooms' do
      at = ActivityTimetable.new

      r1 = Room.new(code: '9.09', name: 'made-up room')
      r2 = Room.new(code: '9.10', name: 'made-up room 2')
      r3 = Room.new(code: '9.11', name: 'made-up room 3')

      allow(r1).to receive(:display_str).and_return("#{r1.name} (#{r1.code})")
      allow(r2).to receive(:display_str).and_return("#{r2.name} (#{r2.code})")
      allow(r3).to receive(:display_str).and_return("#{r3.name} (#{r3.code})")

      allow(at).to receive(:rooms).and_return([r1, r2, r3])
      expected = "#{r1.display_str}, #{r2.display_str}, #{r3.display_str}"
      expect(at.other_room_str).to eq expected
    end
  end

end
